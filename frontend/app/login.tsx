
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import Logo from '../components/Logo';

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function LoginScreen() {
    const router = useRouter();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [submitted, setSubmitted] = useState(false);

    const handleLogin = () => {
        setSubmitted(true);
        if (!emailRegex.test(email) || password.length < 6) {
            return;
        }

        router.replace('/home');
    };

    return (
        <View className="flex-1 bg-white px-6 pt-14">
            <View className="items-center mb-8">
                <Logo width={220} height={90} />
                <Text className="text-3xl font-semibold text-black mt-6">Welcome Back</Text>
                <Text className="text-sm text-gray-500 mt-2 text-center">
                    Login to discover nearby deals, manage your profile, and redeem offers.
                </Text>
            </View>

            <View className="space-y-5">
                <View className="space-y-2">
                    <Text className="text-sm text-gray-700">Email</Text>
                    <TextInput
                        value={email}
                        onChangeText={setEmail}
                        keyboardType="email-address"
                        autoCapitalize="none"
                        autoCorrect={false}
                        placeholder="you@example.com"
                        className="h-13 rounded-3xl border border-gray-300 px-4 bg-slate-50 text-base text-black"
                        placeholderTextColor="#9CA3AF"
                    />
                    {submitted && !emailRegex.test(email) ? (
                        <Text className="text-xs text-red-500">Please enter a valid email.</Text>
                    ) : null}
                </View>

                <View className="space-y-2">
                    <Text className="text-sm text-gray-700">Password</Text>
                    <TextInput
                        value={password}
                        onChangeText={setPassword}
                        secureTextEntry
                        placeholder="Minimum 6 characters"
                        className="h-13 rounded-3xl border border-gray-300 px-4 bg-slate-50 text-base text-black"
                        placeholderTextColor="#9CA3AF"
                    />
                    {submitted && password.length < 6 ? (
                        <Text className="text-xs text-red-500">Password must be at least 6 characters.</Text>
                    ) : null}
                </View>
            </View>

            <TouchableOpacity
                activeOpacity={0.8}
                onPress={handleLogin}
                className="mt-10 rounded-3xl bg-blue-600 px-5 py-4 shadow-md shadow-blue-200"
            >
                <Text className="text-center text-base font-semibold text-white">Log in</Text>
            </TouchableOpacity>

            <View className="flex-row justify-center mt-6">
                <Text className="text-sm text-gray-500">Don't have an account? </Text>
                <Text
                    className="text-sm font-semibold text-blue-600"
                    onPress={() => router.push('/signup')}
                >
                    Sign up
                </Text>
            </View>
        </View>
    );
}
