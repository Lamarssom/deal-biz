
import React, { useState } from 'react';
import { ScrollView, View, Text, TextInput, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import Logo from '../components/Logo';

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function SignupScreen() {
  const router = useRouter();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleSignup = () => {
    setSubmitted(true);
    if (!name.trim() || !emailRegex.test(email) || password.length < 6 || password !== confirmPassword) {
      return;
    }

    router.replace('/home');
  };

  return (
    <ScrollView
      className="flex-1 bg-slate-50"
      contentContainerStyle={{ paddingTop: 40, paddingHorizontal: 24, paddingBottom: 40 }}
    >
      <View className="items-center mb-10">
        <Logo width={200} height={80} />
        <Text className="text-3xl font-semibold text-black mt-6">Create Account</Text>
        <Text className="text-sm text-gray-500 mt-3 text-center leading-6">
          Sign up to unlock local deals, merchant tools, and a tailored dashboard.
        </Text>
      </View>

      <View className="rounded-[32px] bg-white p-6 shadow-md shadow-slate-200">
        <View className="space-y-5">
          <View className="space-y-2">
            <Text className="text-sm font-medium text-slate-700">Full Name</Text>
            <View className="flex-row items-center rounded-3xl border border-slate-200 bg-slate-50 px-4 py-3">
              <Feather name="user" size={20} color="#64748B" />
              <TextInput
                value={name}
                onChangeText={setName}
                placeholder="Your full name"
                className="ml-3 flex-1 text-base text-black"
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !name.trim() ? (
              <Text className="text-xs text-red-500">Please enter your name.</Text>
            ) : null}
          </View>

          <View className="space-y-2">
            <Text className="text-sm font-medium text-slate-700">Email</Text>
            <View className="flex-row items-center rounded-3xl border border-slate-200 bg-slate-50 px-4 py-3">
              <Feather name="mail" size={20} color="#64748B" />
              <TextInput
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                autoCorrect={false}
                placeholder="you@example.com"
                className="ml-3 flex-1 text-base text-black"
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !emailRegex.test(email) ? (
              <Text className="text-xs text-red-500">Enter a valid email address.</Text>
            ) : null}
          </View>

          <View className="space-y-2">
            <Text className="text-sm font-medium text-slate-700">Password</Text>
            <View className="flex-row items-center rounded-3xl border border-slate-200 bg-slate-50 px-4 py-3">
              <Feather name="lock" size={20} color="#64748B" />
              <TextInput
                value={password}
                onChangeText={setPassword}
                secureTextEntry
                placeholder="Minimum 6 characters"
                className="ml-3 flex-1 text-base text-black"
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && password.length < 6 ? (
              <Text className="text-xs text-red-500">Password must be at least 6 characters.</Text>
            ) : null}
          </View>

          <View className="space-y-2">
            <Text className="text-sm font-medium text-slate-700">Confirm Password</Text>
            <View className="flex-row items-center rounded-3xl border border-slate-200 bg-slate-50 px-4 py-3">
              <Feather name="repeat" size={20} color="#64748B" />
              <TextInput
                value={confirmPassword}
                onChangeText={setConfirmPassword}
                secureTextEntry
                placeholder="Repeat your password"
                className="ml-3 flex-1 text-base text-black"
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && password !== confirmPassword ? (
              <Text className="text-xs text-red-500">Passwords do not match.</Text>
            ) : null}
          </View>
        </View>

        <TouchableOpacity
          activeOpacity={0.85}
          onPress={handleSignup}
          className="mt-8 rounded-3xl bg-sky-600 px-5 py-4"
        >
          <Text className="text-center text-base font-semibold text-white">Create account</Text>
        </TouchableOpacity>
      </View>

      <View className="flex-row justify-center mt-7">
        <Text className="text-sm text-slate-500">Already have an account? </Text>
        <Text className="text-sm font-semibold text-sky-600" onPress={() => router.push('/login')}>
          Log in
        </Text>
      </View>
    </ScrollView>
  );
}
