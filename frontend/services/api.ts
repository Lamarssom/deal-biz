import * as SecureStore from 'expo-secure-store';

const API_BASE_URL = 'http://localhost:3000';

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

class ApiService {
  private token: string | null = null;

  async init() {
    try {
      this.token = await SecureStore.getItemAsync('auth_token');
    } catch (error) {
      console.log('Error loading token:', error);
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

  async removeToken() {
    try {
      await SecureStore.deleteItemAsync('auth_token');
      this.token = null;
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
    return response;
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
}

export const apiService = new ApiService();
