
import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import Logo from '../components/Logo';

export default function WelcomeScreen() {
    const router = useRouter();

    return (
        <View className="flex-1 bg-white px-6 pt-14">
            <View className="items-center mb-10">
                <Logo width={240} height={90} />
                <Text className="text-4xl font-semibold text-black mt-8 text-center">Welcome to Sharp Deals</Text>
                <Text className="text-base text-gray-500 mt-4 text-center leading-7">
                    Find local promotions, manage customer and merchant flows, and save on every purchase.
                </Text>
            </View>

            <View className="space-y-4">
                <View className="rounded-3xl bg-slate-100 p-6">
                    <Text className="text-lg font-semibold text-black">Fast access</Text>
                    <Text className="text-sm text-gray-600 mt-2">
                        Sign in or sign up to start exploring deals tailored for your role.
                    </Text>
                </View>

                <View className="rounded-3xl bg-slate-100 p-6">
                    <Text className="text-lg font-semibold text-black">Secure auth</Text>
                    <Text className="text-sm text-gray-600 mt-2">
                        We support secure login flows and role-aware navigation for customers and merchants.
                    </Text>
                </View>
            </View>

            <TouchableOpacity
                activeOpacity={0.8}
                onPress={() => router.push('/login')}
                className="mt-10 rounded-3xl bg-blue-600 px-5 py-4 shadow-md shadow-blue-200"
            >
                <Text className="text-center text-base font-semibold text-white">Log in</Text>
            </TouchableOpacity>

            <TouchableOpacity
                activeOpacity={0.8}
                onPress={() => router.push('/signup')}
                className="mt-4 rounded-3xl border border-blue-600 px-5 py-4"
            >
                <Text className="text-center text-base font-semibold text-blue-600">Create account</Text>
            </TouchableOpacity>
        </View>
    );
}
