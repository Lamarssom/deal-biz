import React, { useState } from 'react';
import {
  ScrollView,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';
import Logo from '../components/Logo';
import { apiService } from '../services/api';

export default function ForgotPasswordScreen() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const handleSendResetLink = async () => {
    setSubmitted(true);
    if (!email.trim()) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Please enter your email' });
      return;
    }

    setIsSubmitting(true);
    try {
      await apiService.forgotPassword({ email: email.trim().toLowerCase() });
      Toast.show({
        type: 'success',
        text1: 'Reset link sent!',
        text2: 'Check your email (and spam folder)',
      });
      router.replace('/login');
    } catch (error: any) {
      Toast.show({
        type: 'error',
        text1: 'Failed',
        text2: error?.message || 'Please try again',
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1, backgroundColor: '#F8FAFC' }}
    >
      <ScrollView
        style={{ flex: 1 }}
        contentContainerStyle={{ flexGrow: 1, padding: 24 }}
        keyboardShouldPersistTaps="handled"
      >
        <View style={{ alignItems: 'center', marginTop: 40 }}>
          <Logo width={180} height={70} />
          <Text style={{ fontSize: 24, fontWeight: '700', marginTop: 24, textAlign: 'center' }}>
            Forgot Password
          </Text>
          <Text style={{ fontSize: 16, color: '#64748B', marginTop: 8, textAlign: 'center' }}>
            Enter your email and we'll send you a reset link
          </Text>
        </View>

        <View style={{ marginTop: 40 }}>
          <View style={{ marginBottom: 16 }}>
            <Text style={{ fontSize: 15, fontWeight: '600', marginBottom: 8 }}>Email Address</Text>
            <View style={{
              flexDirection: 'row',
              alignItems: 'center',
              backgroundColor: '#fff',
              borderRadius: 12,
              paddingHorizontal: 16,
              borderWidth: 1,
              borderColor: '#E2E8F0',
            }}>
              <Feather name="mail" size={20} color="#64748B" />
              <TextInput
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                placeholder="you@example.com"
                style={{ flex: 1, paddingVertical: 14, marginLeft: 12, fontSize: 16 }}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !email.trim() && (
              <Text style={{ color: '#EF4444', fontSize: 13, marginTop: 6 }}>Email is required</Text>
            )}
          </View>

          <TouchableOpacity
            style={{
              backgroundColor: '#1C8EDA',
              paddingVertical: 16,
              borderRadius: 999,
              alignItems: 'center',
              marginTop: 24,
              opacity: isSubmitting ? 0.7 : 1,
            }}
            onPress={handleSendResetLink}
            disabled={isSubmitting}
          >
            <Text style={{ color: '#fff', fontSize: 17, fontWeight: '600' }}>
              {isSubmitting ? 'Sending...' : 'Send Reset Link'}
            </Text>
          </TouchableOpacity>
        </View>

        <TouchableOpacity
          style={{ marginTop: 32, alignItems: 'center' }}
          onPress={() => router.push('/login')}
        >
          <Text style={{ color: '#64748B', fontSize: 15 }}>Back to Login</Text>
        </TouchableOpacity>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}