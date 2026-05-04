import * as SecureStore from 'expo-secure-store';

const API_BASE_URL = 'http://localhost:3000';

export interface ApiResponse<T> {
  data?: T;
  status: string;
  statusCode: number;
  message?: string;
}

export interface RegisterPayload {
  email: string;
  password: string;
  name: string;
  role: 'MERCHANT' | 'CUSTOMER';
  businessName?: string;
  category?: string;
  businessLGA: string;
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
  access_token: string;
  user: {
    id: string;
    email: string;
    role: string;
  };
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
  ): Promise<ApiResponse<T>> {
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

      return data;
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
    
    if (response.data?.access_token) {
      await this.saveToken(response.data.access_token);
    }
    
    return response.data!;
  }

  async login(payload: LoginPayload): Promise<AuthResponse> {
    const response = await this.request<AuthResponse>(
      '/auth/login',
      'POST',
      payload
    );
    
    if (response.data?.access_token) {
      await this.saveToken(response.data.access_token);
    }
    
    return response.data!;
  }

  // Location endpoints
  async getStates(): Promise<State[]> {
    const response = await this.request<State[]>(
      '/location/states',
      'GET',
      undefined,
      true
    );
    return response.data || [];
  }

  async getLGAs(state?: string): Promise<LGA[]> {
    const endpoint = state 
      ? `/location/lga?state=${encodeURIComponent(state)}`
      : '/location/lga';
    
    const response = await this.request<LGA[]>(
      endpoint,
      'GET',
      undefined,
      true
    );
    return response.data || [];
  }
}

export const apiService = new ApiService();
