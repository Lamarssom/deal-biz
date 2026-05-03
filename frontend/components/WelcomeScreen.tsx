import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import Logo from './Logo';

export default function WelcomeScreen() {
  const router = useRouter();

  return (
    <View className="flex-1 bg-slate-50 px-6 pt-14">
      <View className="rounded-[40px] bg-white p-6 shadow-md shadow-slate-200">
        <View className="items-center mb-8">
          <Logo width={210} height={80} />
          <Text className="text-4xl font-semibold text-black mt-8 text-center">
            Welcome to Sharp Deals
          </Text>
          <Text className="text-base text-slate-500 mt-4 text-center leading-7">
            Explore local promotions, save on every purchase, and manage deals from one easy dashboard.
          </Text>
        </View>

        <View className="space-y-4">
          <View className="rounded-[28px] bg-sky-50 p-5">
            <Text className="text-lg font-semibold text-slate-900">Discover nearby deals</Text>
            <Text className="text-sm text-slate-600 mt-2 leading-6">
              Get curated offers from local merchants and stay ahead with limited-time promotions.
            </Text>
          </View>

          <View className="rounded-[28px] bg-slate-100 p-5">
            <Text className="text-lg font-semibold text-slate-900">Seamless sign in</Text>
            <Text className="text-sm text-slate-600 mt-2 leading-6">
              Choose your flow, then log in or create an account to start saving instantly.
            </Text>
          </View>
        </View>
      </View>

      <TouchableOpacity
        activeOpacity={0.85}
        onPress={() => router.push('/login')}
        className="mt-10 rounded-3xl bg-sky-600 px-5 py-4 shadow-md shadow-sky-200"
      >
        <Text className="text-center text-base font-semibold text-white">Log in</Text>
      </TouchableOpacity>

      <TouchableOpacity
        activeOpacity={0.85}
        onPress={() => router.push('/signup')}
        className="mt-4 rounded-3xl border border-slate-300 bg-white px-5 py-4"
      >
        <Text className="text-center text-base font-semibold text-slate-900">Create account</Text>
      </TouchableOpacity>
    </View>
  );
}
