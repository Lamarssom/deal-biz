import React, { useEffect } from 'react';
import { View, Text } from 'react-native';
import { useRouter } from 'expo-router';
import Logo from '../components/Logo';

export default function SplashScreen() {
  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      router.replace('/welcome');
    }, 2500); // 2.5 seconds

    return () => clearTimeout(timer);
  }, [router]);

  return (
    <View className="flex-1 bg-white items-center justify-center">
      {/* Status Bar simulation - already handled in layout */}
      
      <View className="items-center">
        <Logo width={280} height={140} />
        
        <Text className="text-black text-xl font-medium mt-8 tracking-wide">
          Sharp Deals
        </Text>
      </View>

      {/* Optional loading indicator at bottom */}
      <View className="absolute bottom-12">
        <Text className="text-gray-400 text-sm">Loading...</Text>
      </View>
    </View>
  );
}