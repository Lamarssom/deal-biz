import Constants from 'expo-constants';
import { Platform } from 'react-native';

const getApiBaseUrl = () => {
  const envUrl = process.env.EXPO_PUBLIC_API_URL;
  
  //console.log('[CONFIG] EXPO_PUBLIC_API_URL from .env =', envUrl);
  
  if (envUrl) {
    //console.log('[CONFIG] Using .env URL:', envUrl);
    return envUrl;
  }

  if (__DEV__) {
    if (Platform.OS === 'web') {
      //console.log('🌐 [CONFIG] Using web localhost fallback');
      return 'http://localhost:3000';
    }
    //console.log('📱 [CONFIG] Using hardcoded phone fallback (should not see this)');
    return 'http://192.168.1.101:3000';
  }

  return 'https://api.yudeel.com';
};

export const API_BASE_URL = getApiBaseUrl();

export const CLOUDINARY_CLOUD_NAME = process.env.EXPO_PUBLIC_CLOUDINARY_CLOUD_NAME || 'dzvajdc4b';
export const CLOUDINARY_UPLOAD_PRESET = process.env.EXPO_PUBLIC_CLOUDINARY_UPLOAD_PRESET || 'dealbiz';

//console.log('FINAL API_BASE_URL =', API_BASE_URL);