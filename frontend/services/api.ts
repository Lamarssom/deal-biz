import * as SecureStore from 'expo-secure-store';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';
import NetInfo from '@react-native-community/netinfo';
import { API_BASE_URL, CLOUDINARY_CLOUD_NAME, CLOUDINARY_UPLOAD_PRESET } from '../constants/config';

export interface RegisterPayload {
  email: string;
  password: string;
  name: string;
  role: 'MERCHANT' | 'CUSTOMER';
  phoneNumber?: string;
  businessName?: string;
  category?: string;
  businessLGA?: string;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface VerifyOtpPayload {
  email: string;
  code: string;
}

export interface ForgotPasswordPayload {
  email: string;
}

export interface ResetPasswordPayload {          // ← NEW
  token: string;
  newPassword: string;
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
    isProfileComplete: boolean;
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
      if (Platform.OS !== 'web') {
        this.token = await SecureStore.getItemAsync('auth_token');
      } else {
        this.token = await AsyncStorage.getItem('auth_token');
      }

      const userData = await AsyncStorage.getItem('user_data');
      if (userData) this.user = JSON.parse(userData);

      console.log('[API] init complete → token:', !!this.token, 'userId:', this.user?.id);
    } catch (error) {
      console.log('Error loading token/user:', error);
    }
  }

  setToken(token: string) { this.token = token; }

  async saveToken(token: string) {
    try {
      if (Platform.OS !== 'web') {
        await SecureStore.setItemAsync('auth_token', token);
      } else {
        await AsyncStorage.setItem('auth_token', token);
      }
      this.token = token;
      console.log('[API] Token saved successfully');
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

  getUser() { return this.user; }

  async clearCache() {
    if (!this.user?.id) return;
    try {
      await AsyncStorage.multiRemove([
        `@deal_biz_cache_favourites_${this.user.id}`,
        `@deal_biz_cache_nearby_${this.user.id}`,
        `@deal_biz_cache_redemptions_${this.user.id}`,
        `@deal_biz_cache_promotions_${this.user.id}`,
        `@deal_biz_cache_analytics_${this.user.id}`,
      ]);
      console.log(`[API] All caches cleared for user ${this.user.id}`);
    } catch (e) {}
  }

  private getCacheKey(baseKey: string): string {
    return this.user?.id ? `${baseKey}_${this.user.id}` : baseKey;
  }

    private async request<T>(
    endpoint: string,
    method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE' = 'GET',
    body?: any,
    isAuth: boolean = false,
    cacheKeyBase?: string
  ): Promise<T> {
    const maxRetries = 3;
    let attempt = 0;

    while (attempt < maxRetries) {
      try {
        const headers: HeadersInit = { 'Content-Type': 'application/json' };

        if (isAuth && !this.token) {
          await this.init();
        }
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
          if (response.status === 401) {
            console.log('[API] 401 Unauthorized → auto-logout');
            await this.removeToken();
          }
          throw new Error(data.message || `API Error: ${response.status}`);
        }

        if (method === 'GET' && cacheKeyBase) {
          const cacheKey = this.getCacheKey(cacheKeyBase);
          await AsyncStorage.setItem(cacheKey, JSON.stringify(data));
        }

        return data as T;
      } catch (error: any) {
        attempt++;

        const netState = await NetInfo.fetch();
        if ((!netState.isConnected || !navigator.onLine) && cacheKeyBase) {
          const cacheKey = this.getCacheKey(cacheKeyBase);
          const cached = await AsyncStorage.getItem(cacheKey);
          if (cached) return JSON.parse(cached) as T;
        }

        if (attempt === maxRetries) throw error;

        await new Promise(resolve => setTimeout(resolve, 400 * Math.pow(2, attempt - 1)));
      }
    }
    throw new Error('Request failed after retries');
  }

  // Auth
  async register(payload: RegisterPayload): Promise<AuthResponse> {
    return this.request<AuthResponse>('/auth/register', 'POST', payload);
  }

  async login(payload: LoginPayload): Promise<AuthResponse> {
    return this.request<AuthResponse>('/auth/login', 'POST', payload);
  }

  async googleLogin(idToken: string): Promise<any> {
    return this.request<any>('/auth/google', 'POST', { idToken }, false);
  }

  async appleLogin(identityToken: string, fullName?: string): Promise<any> {
    return this.request<any>('/auth/apple', 'POST', { identityToken, fullName }, false);
  }

  async verifyOtp(payload: VerifyOtpPayload): Promise<any> {
    return this.request<any>('/auth/verify-otp', 'POST', payload);
  }

  async forgotPassword(payload: ForgotPasswordPayload): Promise<any> {
    return this.request<any>('/auth/forgot-password', 'POST', payload);
  }

  async resetPassword(payload: ResetPasswordPayload): Promise<any> {   // ← NEW
    return this.request<any>('/auth/reset-password', 'POST', payload);
  }

  // Cached endpoints (user-specific)
  async getNearbyPromotions(lat: number, lng: number, radius: number = 10): Promise<NearbyPromotion[]> {
    return this.request<NearbyPromotion[]>(
      `/promotions/nearby?lat=${lat}&lng=${lng}&radius=${radius}`,
      'GET', undefined, true, '@deal_biz_cache_nearby'
    );
  }

  async getMyFavourites(): Promise<any[]> {
    return this.request<any[]>('/favourites', 'GET', undefined, true, '@deal_biz_cache_favourites');
  }

  async getMyRedemptions(): Promise<any[]> {
    return this.request<any[]>('/redemptions/my', 'GET', undefined, true, '@deal_biz_cache_redemptions');
  }

  async getMyPromotions(): Promise<any[]> {
    return this.request<any[]>('/promotions/my', 'GET', undefined, true, '@deal_biz_cache_promotions');
  }

    async updatePromotionQuantity(promotionId: string, quantityLimit: number): Promise<any> {
    return this.request<any>(
      `/promotions/${promotionId}/quantity`,
      'PATCH',
      { quantityLimit },
      true
    );
  }

  async getMerchantAnalytics(): Promise<any> {
    return this.request<any>('/analytics/merchant', 'GET', undefined, true, '@deal_biz_cache_analytics');
  }

  // Other endpoints
  async getStates(): Promise<State[]> {
    return this.request<State[]>('/location/states', 'GET', undefined, false);
  }

  async getLGAs(state?: string): Promise<LGA[]> {
    const endpoint = state ? `/location/lga?state=${encodeURIComponent(state)}` : '/location/lga';
    return this.request<LGA[]>(endpoint, 'GET', undefined, false);
  }

  async createPromotionWithPayment(data: CreatePromotionPayload): Promise<PromotionPaymentResponse> {
    return this.request<PromotionPaymentResponse>('/promotions', 'POST', data, true);
  }

  async settleMerchantBalance(payload: SettleBalancePayload): Promise<any> {
    return this.request<any>('/merchants/settle-balance', 'POST', payload, true);
  }

  async generateQR(payload: { promotionId: string; quantity: number }): Promise<GenerateQRResponse> {
    return this.request<GenerateQRResponse>('/redemptions/generate', 'POST', payload, true);
  }

  async redeem(qrCode: string): Promise<any> {
    return this.request<any>('/redemptions/redeem', 'POST', { qrCode }, true);
  }

  async uploadImageToCloudinary(uri: string): Promise<string> {
    if (Platform.OS === 'web') throw new Error('Image upload not supported on web yet');

    const formData = new FormData();
    formData.append('file', { uri, type: 'image/jpeg', name: 'promotion.jpg' } as any);
    formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);

    const response = await fetch(
      `https://api.cloudinary.com/v1_1/${CLOUDINARY_CLOUD_NAME}/image/upload`,
      { method: 'POST', body: formData }
    );

    const data = await response.json();
    if (data.secure_url) return data.secure_url;
    throw new Error('Failed to upload image');
  }

  async addFavourite(promotionId: string): Promise<any> {
    return this.request<any>(`/favourites/${promotionId}`, 'POST', undefined, true);
  }

  async removeFavourite(promotionId: string): Promise<any> {
    return this.request<any>(`/favourites/${promotionId}`, 'DELETE', undefined, true);
  }

  async removeToken() {
    try {
      if (Platform.OS !== 'web') {
        await SecureStore.deleteItemAsync('auth_token');
      } else {
        await AsyncStorage.removeItem('auth_token');
      }
      await AsyncStorage.removeItem('user_data');
      this.token = null;
      this.user = null;
      console.log('[API] Token and user data removed successfully');
    } catch (error) {
      console.log('Error removing token:', error);
    }
  }

  async changePassword(oldPassword: string, newPassword: string) {
    return this.request<any>('/auth/change-password', 'POST', { oldPassword, newPassword }, true);
  }

  async updatePhoneNumber(phoneNumber: string) {
    return this.request<any>('/auth/update-phone', 'POST', { phoneNumber }, true);
  }

  async getProfile() {
    return this.request<any>('/auth/profile', 'GET', undefined, true);
  }
  
}

export const apiService = new ApiService();