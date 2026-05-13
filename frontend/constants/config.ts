import Constants from 'expo-constants';

const getApiBaseUrl = () => {
  if (__DEV__) {
    return Constants.expoConfig?.extra?.apiBaseUrl || 'http://192.168.0.168:3000';
  }

  // Production URL (update once deploy the backend)
  //return 'https://your-production-backend.com';
};

export const API_BASE_URL = getApiBaseUrl();

export const CLOUDINARY_CLOUD_NAME = 'dzvajdc4b';
export const CLOUDINARY_UPLOAD_PRESET = 'dealbiz';