import React from 'react';
import { Stack } from 'expo-router';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';
import { AuthProvider, useAuth } from '../context/AuthContext';
import '../global.css';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { isSignedIn, isLoading } = useAuth();

  // Show loading while checking auth status
  if (isLoading) {
    return null; // Or a loading spinner
  }

  // If not signed in, this will redirect to login (handled by individual screens)
  return <>{children}</>;
}

export default function RootLayout() {
  return (
    <AuthProvider>
      <SafeAreaProvider>
        <StatusBar style="dark" backgroundColor="#FFFFFF" />

        <Stack
          screenOptions={{
            headerShown: false,
            contentStyle: { 
              backgroundColor: '#FFFFFF',
              flex: 1,
            },
            animation: 'fade',
          }}
        >
          <Stack.Screen name="index" />
          <Stack.Screen name="welcome" />
          <Stack.Screen name="login" options={{ animation: 'slide_from_right' }} />
          <Stack.Screen name="signup" options={{ animation: 'slide_from_right' }} />
          <Stack.Screen name="verify-email" options={{ animation: 'slide_from_right' }} />
          <Stack.Screen 
            name="home" 
            options={{ animation: 'slide_from_right' }}
            // Protection will be handled in the home component itself
          />
        </Stack>
      </SafeAreaProvider>
    </AuthProvider>
  );
}