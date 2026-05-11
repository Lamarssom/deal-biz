import React from 'react';
import { Tabs } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import { useAuth } from '../../context/AuthContext';

export default function TabLayout() {
  const { user, isLoading } = useAuth();

  if (isLoading) return null;

  const isMerchant = user?.role === 'MERCHANT';

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: '#1C8EDA',
        tabBarInactiveTintColor: '#64748B',
        tabBarStyle: {
          backgroundColor: '#FFFFFF',
          borderTopWidth: 1,
          borderTopColor: '#E2E8F0',
          height: 60,
          paddingBottom: 8,
        },
        headerShown: false,
      }}
      initialRouteName="home"
    >
      <Tabs.Screen name="home" options={{ title: 'Home', tabBarIcon: ({ color, size }) => <Feather name="home" size={size} color={color} /> }} />
      <Tabs.Screen name="redemptions" options={{ title: 'My Activity', tabBarIcon: ({ color, size }) => <Feather name="tag" size={size} color={color} /> }} />

      {/* Scan tab - now 100% hidden for customers */}
      <Tabs.Screen
        name="scan"
        options={{
          title: 'Scan',
          tabBarIcon: ({ color, size }) => <Feather name="camera" size={size} color={color} />,
          href: isMerchant ? undefined : null,   // ← this hides the tab completely
        }}
      />

      <Tabs.Screen name="profile" options={{ title: 'Me', tabBarIcon: ({ color, size }) => <Feather name="user" size={size} color={color} /> }} />
    </Tabs>
  );
}