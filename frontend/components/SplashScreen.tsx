import React, { useEffect } from 'react';
import { View, ActivityIndicator } from 'react-native';
import { useRouter } from 'expo-router';
import Logo from './Logo';
import { splashStyles } from '../styles/splash.styles';
import { useAuth } from '../context/AuthContext';

export default function SplashScreen() {
  const router = useRouter();
  const { isSignedIn, isLoading } = useAuth();

  useEffect(() => {
    const timer = setTimeout(() => {
        router.replace('/home'); 
      }, 1500);

    return () => clearTimeout(timer);
  }, [router]);

  return (
    <View style={splashStyles.container}>
      <Logo width={260} height={130} />
      {isLoading && (
        <ActivityIndicator 
          size="large" 
          color="#1C8EDA" 
          style={{ marginTop: 40 }} 
        />
      )}
    </View>
  );
}