import * as SecureStore from 'expo-secure-store';
import AsyncStorage from '@react-native-async-storage/async-storage';

const API_BASE_URL = __DEV__ 
  ? 'http://192.168.0.168:3000'  // Use IP address for mobile simulators
  : 'http://localhost:3000';     // Use localhost for web development

export interface RegisterPayload {
  email: string;
  password: string;
  name: string;
  role: 'MERCHANT' | 'CUSTOMER';
  businessName?: string;
  category?: string;
  businessLGA?: string;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface State {
  id: number;
  state: string;
}

export interface LGA {
  id: number;
  lga: string;
  state: string;
}

export interface AuthResponse {
  accessToken?: string;
  access_token?: string;
  user?: {
    id: string;
    email: string;
    role: string;
  };
  message?: string;
}

export interface CreatePromotionPayload {
  type: string;
  title: string;
  price: number;
  originalPrice: number;
  expiry: string;
  quantityLimit: number;
  description?: string;
  photoUrl?: string;
  radiusKm?: number;
}

export interface PromotionPaymentResponse {
  message: string;
  promotionId: string;
  paystackReference: string;
  authorizationUrl: string;
  fee: number;
  type: string;
}

export interface SettleBalancePayload {
  amount: number;
}

export interface NearbyPromotion {
  id: string;
  title: string;
  type: string;
  price: number;
  originalPrice: number;
  expiry: string;
  quantityLimit: number;
  redeemedCount: number;
  views: number;
  distanceKm: number;
  merchant: {
    id: string;
    businessName: string;
    category: string;
    businessLGA: string;
  };
}

export interface GenerateQRResponse {
  redemptionId: string;
  qrCode: string;
  qrImage: string;
  message: string;
}

class ApiService {
  private token: string | null = null;
  private user: any = null;

  async init() {
    try {
      this.token = await SecureStore.getItemAsync('auth_token');
      const userData = await AsyncStorage.getItem('user_data');
      if (userData) {
        this.user = JSON.parse(userData);
      }
    } catch (error) {
      console.log('Error loading token/user:', error);
    }
  }

  setToken(token: string) {
    this.token = token;
  }

  async saveToken(token: string) {
    try {
      await SecureStore.setItemAsync('auth_token', token);
      this.token = token;
    } catch (error) {
      console.log('Error saving token:', error);
    }
  }

  async saveUser(user: any) {
    try {
      await AsyncStorage.setItem('user_data', JSON.stringify(user));
      this.user = user;
    } catch (error) {
      console.log('Error saving user:', error);
    }
  }

  getUser() {
    return this.user;
  }

  async removeToken() {
    try {
      await SecureStore.deleteItemAsync('auth_token');
      await AsyncStorage.removeItem('user_data');
      this.token = null;
      this.user = null;
    } catch (error) {
      console.log('Error removing token:', error);
    }
  }

  private async request<T>(
    endpoint: string,
    method: 'GET' | 'POST' | 'PUT' | 'DELETE' = 'GET',
    body?: any,
    isAuth: boolean = false
  ): Promise<T> {
    try {
      const headers: HeadersInit = {
        'Content-Type': 'application/json',
      };

      if (isAuth && this.token) {
        headers['Authorization'] = `Bearer ${this.token}`;
      }

      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method,
        headers,
        body: body ? JSON.stringify(body) : undefined,
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || `API Error: ${response.status}`);
      }

      return data as T;
    } catch (error) {
      console.log('API Error:', error);
      throw error;
    }
  }

  // Auth endpoints
  async register(payload: RegisterPayload): Promise<AuthResponse> {
    const response = await this.request<AuthResponse>(
      '/auth/register',
      'POST',
      payload
    );
    const token = response.accessToken || response.access_token;
    if (token) {
      await this.saveToken(token);
      this.token = token;
    }
    if (response.user) {
      await this.saveUser(response.user);
    }
    return response;
  }

  async login(payload: LoginPayload): Promise<AuthResponse> {
    const response = await this.request<AuthResponse>(
      '/auth/login',
      'POST',
      payload
    );
    const token = response.accessToken || response.access_token;
    if (token) {
      await this.saveToken(token);
      this.token = token;
    }
    if (response.user) {
      await this.saveUser(response.user);
    }
    return response;
  }

  async verifyEmail(email: string, code: string): Promise<any> {
    return await this.request<any>(
      '/auth/verify-email',
      'POST',
      { email, code },
      false
    );
  }

  // Location endpoints
  async getStates(): Promise<State[]> {
    return await this.request<State[]>(
      '/location/states',
      'GET',
      undefined,
      false
    );
  }

  async getLGAs(state?: string): Promise<LGA[]> {
    const endpoint = state 
      ? `/location/lga?state=${encodeURIComponent(state)}`
      : '/location/lga';
    return await this.request<LGA[]>(
      endpoint,
      'GET',
      undefined,
      false
    );
  }

  // Promotions endpoints
  async createPromotion(data: {
    type: string;
    title: string;
    price: number;
    originalPrice: number;
    expiry: string;
    quantityLimit: number;
  }): Promise<any> {
    return await this.request<any>(
      '/promotions',
      'POST',
      data,
      true
    );
  }

  // Merchant analytics endpoint
  async getMerchantAnalytics(): Promise<any> {
    return await this.request<any>(
      '/analytics/merchant',
      'GET',
      undefined,
      true  // requires auth
    );
  }

    // PROMOTION WITH PAYMENT
  async createPromotionWithPayment(data: CreatePromotionPayload): Promise<PromotionPaymentResponse> {
    return await this.request<PromotionPaymentResponse>(
      '/promotions',
      'POST',
      data,
      true
    );
  }

  // SETTLE BALANCE
  async settleMerchantBalance(payload: SettleBalancePayload): Promise<any> {
    return await this.request<any>(
      '/merchants/settle-balance',
      'POST',
      payload,
      true
    );
  }

  // Verify payment manually
  async verifyPayment(reference: string): Promise<any> {
    return await this.request<any>(
      `/payments/verify/${reference}`,
      'GET',
      undefined,
      true
    );
  }

  async getNearbyPromotions(lat: number, lng: number, radius: number = 10): Promise<NearbyPromotion[]> {
    return await this.request<NearbyPromotion[]>(
      `/promotions/nearby?lat=${lat}&lng=${lng}&radius=${radius}`,
      'GET',
      undefined,
      true 
    );
  }

  async generateQR(payload: { promotionId: string }): Promise<GenerateQRResponse> {
    return await this.request<GenerateQRResponse>(
      '/redemptions/generate',
      'POST',
      payload,
      true
    );
  }
}

export const apiService = new ApiService();
