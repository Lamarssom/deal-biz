import React, { useEffect } from 'react';
import { View } from 'react-native';
import { useRouter } from 'expo-router';
import Logo from './Logo';
import { splashStyles } from '../styles/splash.styles';

export default function SplashScreen() {
  const router = useRouter();

  useEffect(() => {
    const timeout = setTimeout(() => {
      router.replace('/login');
    }, 2500);

    return () => clearTimeout(timeout);
  }, [router]);

  return (
    <View style={splashStyles.container}>
      <Logo width={260} height={130} />
    </View>
  );
}