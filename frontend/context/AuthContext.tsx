import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import * as SecureStore from 'expo-secure-store';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';
import { apiService } from '../services/api';
import { router } from 'expo-router';

interface User {
  id: string;
  email: string;
  role: string;
  name?: string;
  businessName?: string;
  phoneNumber?: string;
  isProfileComplete?: boolean;     // ← NEW
}

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isSignedIn: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (data: any) => Promise<any>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSignedIn, setIsSignedIn] = useState(false);

  useEffect(() => {
    bootstrapAsync();
  }, []);

  const bootstrapAsync = async () => {
    try {
      await apiService.init();

      let token: string | null = null;

      if (Platform.OS !== 'web') {
        token = await SecureStore.getItemAsync('auth_token');
      } else {
        token = await AsyncStorage.getItem('auth_token');
      }

      if (token) {
        const storedUser = apiService.getUser();
        if (storedUser) {
          setUser(storedUser);
          setIsSignedIn(true);

          // Redirect to profile completion if needed
          if (storedUser.isProfileComplete === false) {
            router.replace('/profile-completion');
          }
        }
      }
    } catch (e) {
      console.log('Failed to restore auth:', e);
    } finally {
      setIsLoading(false);
    }
  };

  const login = async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const response = await apiService.login({ email, password });
      
      if (response.accessToken && response.user) {
        await apiService.saveToken(response.accessToken);
        await apiService.saveUser(response.user);
        await apiService.clearCache();
        await apiService.init();

        setUser(response.user);
        setIsSignedIn(true);

        // Check profile completion
        if (response.user.isProfileComplete === false) {
          router.replace('/profile-completion');
        } else {
          router.replace('/(tabs)/home');
        }
      } else {
        throw new Error('Login failed: No token or user received');
      }
    } finally {
      setIsLoading(false);
    }
  };

  const register = async (data: any) => {
    setIsLoading(true);
    try {
      const response = await apiService.register(data);
      if (response.user && response.accessToken) {
        await apiService.saveToken(response.accessToken);
        await apiService.saveUser(response.user);
        await apiService.clearCache();
        await apiService.init();

        setUser(response.user);
        setIsSignedIn(true);

        if (response.user.isProfileComplete === false) {
          router.replace('/profile-completion');
        } else {
          router.replace('/(tabs)/home');
        }
      }
      return response;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    setIsLoading(true);
    try {
      await apiService.clearCache();
      await apiService.removeToken();
      setUser(null);
      setIsSignedIn(false);
      router.replace('/login');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <AuthContext.Provider value={{ user, isLoading, isSignedIn, login, register, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}