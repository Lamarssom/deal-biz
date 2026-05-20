import React from 'react';
import { Stack } from 'expo-router';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';
import { AuthProvider } from '../context/AuthContext';
import { MerchantProvider } from '../context/MerchantContext';
import { FavouritesProvider } from '../context/FavouritesContext';
import { NetworkProvider } from '../context/NetworkContext';
import Toast, { ToastConfig } from 'react-native-toast-message';
import { OfflineBanner } from '../components/ui/OfflineBanner';
import { ErrorBoundary } from '../components/ErrorBoundary';
import { View, Text } from 'react-native';
import { Feather } from '@expo/vector-icons';
import '../global.css';

// Compact Toast config
const toastConfig: ToastConfig = {
  success: ({ text1, text2 }) => (
    <View style={{
      backgroundColor: '#1C8EDA',
      paddingVertical: 12,
      paddingHorizontal: 16,
      borderRadius: 12,
      marginHorizontal: 16,
      flexDirection: 'row',
      alignItems: 'center',
      gap: 10,
      shadowColor: '#000',
      shadowOpacity: 0.1,
      shadowRadius: 8,
      elevation: 4,
    }}>
      <Feather name="check-circle" size={20} color="#FFFFFF" />
      <View style={{ flex: 1 }}>
        <Text style={{ color: '#FFFFFF', fontWeight: '600', fontSize: 15 }}>{text1}</Text>
        {text2 && <Text style={{ color: '#FFFFFF', opacity: 0.9, fontSize: 13 }}>{text2}</Text>}
      </View>
    </View>
  ),

  error: ({ text1, text2 }) => (
    <View style={{
      backgroundColor: '#EF4444',
      paddingVertical: 12,
      paddingHorizontal: 16,
      borderRadius: 12,
      marginHorizontal: 16,
      flexDirection: 'row',
      alignItems: 'center',
      gap: 10,
      shadowColor: '#000',
      shadowOpacity: 0.1,
      shadowRadius: 8,
      elevation: 4,
    }}>
      <Feather name="alert-circle" size={20} color="#FFFFFF" />
      <View style={{ flex: 1 }}>
        <Text style={{ color: '#FFFFFF', fontWeight: '600', fontSize: 15 }}>{text1}</Text>
        {text2 && <Text style={{ color: '#FFFFFF', opacity: 0.9, fontSize: 13 }}>{text2}</Text>}
      </View>
    </View>
  ),
};

export default function RootLayout() {
  return (
    <AuthProvider>
      <NetworkProvider>
        <FavouritesProvider>
          <MerchantProvider>
            <SafeAreaProvider>
              <StatusBar style="dark" backgroundColor="#FFFFFF" />

              <OfflineBanner />

              {/* Global Error Boundary wraps everything */}
              <ErrorBoundary>
                <Stack
                  screenOptions={{
                    headerShown: false,
                    contentStyle: { backgroundColor: '#FFFFFF', flex: 1 },
                    animation: 'fade',
                  }}
                >
                  <Stack.Screen name="index" />
                  <Stack.Screen name="welcome" />
                  <Stack.Screen name="login" options={{ animation: 'slide_from_right' }} />
                  <Stack.Screen name="signup" options={{ animation: 'slide_from_right' }} />
                  <Stack.Screen name="verify-otp" options={{ animation: 'slide_from_right' }} />
                  <Stack.Screen name="(tabs)" />
                </Stack>
              </ErrorBoundary>

              <Toast config={toastConfig} />
            </SafeAreaProvider>
          </MerchantProvider>
        </FavouritesProvider>
      </NetworkProvider>
    </AuthProvider>
  );
}