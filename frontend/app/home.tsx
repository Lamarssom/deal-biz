
import React from 'react';
import { ScrollView, View, Text, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';

export default function HomeScreen() {
  const router = useRouter();

  return (
    <ScrollView
      className="flex-1 bg-slate-50"
      contentContainerStyle={{ paddingTop: 40, paddingHorizontal: 24, paddingBottom: 40 }}
    >
      <View className="flex-row items-start justify-between mb-8">
        <View>
          <Text className="text-sm text-slate-500">Good morning</Text>
          <Text className="text-3xl font-semibold text-slate-900 mt-1">Find your next deal</Text>
        </View>
        <TouchableOpacity
          className="rounded-full border border-slate-200 bg-white px-4 py-3"
          activeOpacity={0.85}
          onPress={() => router.replace('/login')}
        >
          <Text className="text-sm font-semibold text-slate-700">Logout</Text>
        </TouchableOpacity>
      </View>

      <View className="rounded-[32px] bg-white p-6 shadow-md shadow-slate-200 mb-6">
        <Text className="text-lg font-semibold text-slate-900">Local deals just for you</Text>
        <Text className="text-sm text-slate-600 mt-3 leading-6">
          Explore nearby promotions, save favorites, and redeem offers from merchants in your area.
        </Text>
      </View>

      <View className="space-y-4">
        <View className="rounded-[28px] bg-white p-5 shadow-sm shadow-slate-200">
          <Text className="text-base font-semibold text-slate-900">Featured deal</Text>
          <Text className="text-sm text-slate-600 mt-3 leading-6">
            ₦1,500 off on your next order from a top merchant. Valid for today only.
          </Text>
        </View>

        <View className="rounded-[28px] bg-sky-600 p-5 shadow-sm shadow-sky-200">
          <Text className="text-base font-semibold text-white">Nearby promotions</Text>
          <Text className="text-sm text-sky-100 mt-3 leading-6">
            Browse real-time offers with distance, merchant ratings, and limited-time countdowns.
          </Text>
        </View>

        <View className="rounded-[28px] bg-white p-5 shadow-sm shadow-slate-200">
          <Text className="text-base font-semibold text-slate-900">Merchant tools</Text>
          <Text className="text-sm text-slate-600 mt-3 leading-6">
            Access promo creation, redemption scanning, and campaign analytics from one place.
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}
