import { Stack } from 'expo-router';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';
import { AuthProvider } from '../context/AuthContext';
import '../global.css';

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
          <Stack.Screen name="home" options={{ animation: 'slide_from_right' }} />
        </Stack>
      </SafeAreaProvider>
    </AuthProvider>
  );
}