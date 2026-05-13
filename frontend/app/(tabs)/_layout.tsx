import React from 'react';
import { Tabs } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import { useAuth } from '../../context/AuthContext';

export default function TabLayout() {
  const { user, isLoading } = useAuth();

  if (isLoading) return null;

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
      {/* Home */}
      <Tabs.Screen 
        name="home" 
        options={{ 
          title: 'Home', 
          tabBarIcon: ({ color, size }) => <Feather name="home" size={size} color={color} /> 
        }} 
      />

      {/* New Search Tab */}
      <Tabs.Screen 
        name="search" 
        options={{ 
          title: 'Search', 
          tabBarIcon: ({ color, size }) => <Feather name="search" size={size} color={color} /> 
        }} 
      />

      {/* My Activity (tabified) */}
      <Tabs.Screen 
        name="redemptions" 
        options={{ 
          title: 'Activity', 
          tabBarIcon: ({ color, size }) => <Feather name="tag" size={size} color={color} /> 
        }} 
      />

      {/* Profile */}
      <Tabs.Screen 
        name="profile" 
        options={{ 
          title: 'Me', 
          tabBarIcon: ({ color, size }) => <Feather name="user" size={size} color={color} /> 
        }} 
      />
    </Tabs>
  );
}