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
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';
import Logo from '../components/Logo';
import { apiService } from '../services/api';

export default function ResetPasswordScreen() {
  const router = useRouter();
  const { token } = useLocalSearchParams<{ token: string }>();

  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const handleResetPassword = async () => {
    setSubmitted(true);

    if (!token) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Invalid reset link' });
      return;
    }
    if (newPassword.length < 6) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Password must be at least 6 characters' });
      return;
    }
    if (newPassword !== confirmPassword) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Passwords do not match' });
      return;
    }

    setIsSubmitting(true);
    try {
      await apiService.resetPassword({ token, newPassword });
      Toast.show({ type: 'success', text1: 'Password reset successful!' });
      router.replace('/login');
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Reset failed', text2: error?.message || 'Please try again' });
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
            Reset Password
          </Text>
          <Text style={{ fontSize: 16, color: '#64748B', marginTop: 8, textAlign: 'center' }}>
            Enter your new password
          </Text>
        </View>

        <View style={{ marginTop: 40 }}>
          <View style={{ marginBottom: 16 }}>
            <Text style={{ fontSize: 15, fontWeight: '600', marginBottom: 8 }}>New Password</Text>
            <View style={{
              flexDirection: 'row',
              alignItems: 'center',
              backgroundColor: '#fff',
              borderRadius: 12,
              paddingHorizontal: 16,
              borderWidth: 1,
              borderColor: '#E2E8F0',
            }}>
              <Feather name="lock" size={20} color="#64748B" />
              <TextInput
                value={newPassword}
                onChangeText={setNewPassword}
                secureTextEntry={!showNewPassword}
                placeholder="Minimum 6 characters"
                style={{ flex: 1, paddingVertical: 14, marginLeft: 12, fontSize: 16 }}
                placeholderTextColor="#94A3B8"
              />
              <TouchableOpacity onPress={() => setShowNewPassword(!showNewPassword)}>
                <Feather name={showNewPassword ? "eye" : "eye-off"} size={20} color="#64748B" />
              </TouchableOpacity>
            </View>
          </View>

          <View style={{ marginBottom: 24 }}>
            <Text style={{ fontSize: 15, fontWeight: '600', marginBottom: 8 }}>Confirm New Password</Text>
            <View style={{
              flexDirection: 'row',
              alignItems: 'center',
              backgroundColor: '#fff',
              borderRadius: 12,
              paddingHorizontal: 16,
              borderWidth: 1,
              borderColor: '#E2E8F0',
            }}>
              <Feather name="lock" size={20} color="#64748B" />
              <TextInput
                value={confirmPassword}
                onChangeText={setConfirmPassword}
                secureTextEntry={!showConfirmPassword}
                placeholder="Repeat password"
                style={{ flex: 1, paddingVertical: 14, marginLeft: 12, fontSize: 16 }}
                placeholderTextColor="#94A3B8"
              />
              <TouchableOpacity onPress={() => setShowConfirmPassword(!showConfirmPassword)}>
                <Feather name={showConfirmPassword ? "eye" : "eye-off"} size={20} color="#64748B" />
              </TouchableOpacity>
            </View>
          </View>

          <TouchableOpacity
            style={{
              backgroundColor: '#1C8EDA',
              paddingVertical: 16,
              borderRadius: 999,
              alignItems: 'center',
              opacity: isSubmitting ? 0.7 : 1,
            }}
            onPress={handleResetPassword}
            disabled={isSubmitting}
          >
            <Text style={{ color: '#fff', fontSize: 17, fontWeight: '600' }}>
              {isSubmitting ? 'Resetting...' : 'Reset Password'}
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