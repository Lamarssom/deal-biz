
import React from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { useRouter } from 'expo-router';

export default function HomeScreen() {
    const router = useRouter();

    return (
        <ScrollView className="flex-1 bg-white px-6 pt-14" contentContainerStyle={{ paddingBottom: 40 }}>
            <View className="flex-row items-center justify-between mb-8">
                <View>
                    <Text className="text-sm text-gray-500">Good morning</Text>
                    <Text className="text-3xl font-semibold text-black mt-1">Find your next deal</Text>
                </View>
                <TouchableOpacity
                    className="rounded-full border border-slate-200 bg-slate-100 px-4 py-3"
                    activeOpacity={0.8}
                    onPress={() => router.replace('/login')}
                >
                    <Text className="text-sm font-semibold text-slate-700">Logout</Text>
                </TouchableOpacity>
            </View>

            <View className="rounded-3xl bg-blue-600 p-6 mb-6 shadow-md shadow-blue-100">
                <Text className="text-lg font-semibold text-white">Local deals just for you</Text>
                <Text className="text-sm text-blue-100 mt-3 leading-6">
                    Explore nearby promotions, save favorites, and redeem offers from merchants in your area.
                </Text>
            </View>

            <View className="space-y-4">
                <View className="rounded-3xl border border-slate-200 bg-slate-50 p-5">
                    <Text className="text-base font-semibold text-black">Featured deal</Text>
                    <Text className="text-sm text-gray-600 mt-3">
                        ₦1,500 off on your next order from a top merchant. Valid for today only.
                    </Text>
                </View>

                <View className="rounded-3xl border border-slate-200 bg-white p-5">
                    <Text className="text-base font-semibold text-black">Nearby promotions</Text>
                    <Text className="text-sm text-gray-600 mt-3">
                        Browse real-time offers with distance, rating, and countdown details.
                    </Text>
                </View>

                <View className="rounded-3xl border border-slate-200 bg-slate-50 p-5">
                    <Text className="text-base font-semibold text-black">Merchant tools</Text>
                    <Text className="text-sm text-gray-600 mt-3">
                        Access merchant flows, promo creation, and redemption scanning from one place.
                    </Text>
                </View>
            </View>
        </ScrollView>
    );
}
