import React, { useState } from 'react';
import {
  ScrollView,
  View,
  Text,
  TextInput,
  TouchableOpacity,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';
import Logo from '../components/Logo';
import { apiService } from '../services/api';
import { verifyEmailStyles } from '../styles/verify-email.styles';

export default function VerifyEmailScreen() {
  const router = useRouter();
  const { email: paramEmail } = useLocalSearchParams<{ email: string }>();

  const [email, setEmail] = useState(paramEmail || '');
  const [code, setCode] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const handleVerify = async () => {
    setSubmitted(true);

    if (!email.trim() || code.length !== 6) {
      Toast.show({ type: 'error', text1: 'Validation Error', text2: 'Please enter a valid email and 6-digit code.' });
      return;
    }

    setIsSubmitting(true);
    try {
      const response = await apiService.verifyEmail(email, code);
      Toast.show({ type: 'success', text1: '✅ Email Verified!', text2: 'You can now log in.' });
      router.replace('/(tabs)/home');
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Verification Failed', text2: error?.message || 'Please try again.' });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <ScrollView
      style={verifyEmailStyles.container}
      contentContainerStyle={verifyEmailStyles.scrollContent}
      keyboardShouldPersistTaps="handled"
    >
      <View>
        <View style={verifyEmailStyles.headerContainer}>
          <Logo width={150} height={60} />
          <Text style={verifyEmailStyles.title}>Verify Your Email</Text>
          <Text style={verifyEmailStyles.subtitle}>
            We sent a 6-digit code to your email
          </Text>
          <Text style={verifyEmailStyles.caption}>{email}</Text>
        </View>

        <View style={{ marginBottom: 24 }}>
          <View style={verifyEmailStyles.inputGroup}>
            <Text style={verifyEmailStyles.label}>Email Address</Text>
            <View style={verifyEmailStyles.inputWrapper}>
              <Feather name="mail" size={20} color="#64748B" />
              <TextInput
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                placeholder="your@email.com"
                style={verifyEmailStyles.input}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !email.trim() && (
              <Text style={verifyEmailStyles.errorText}>Email is required</Text>
            )}
          </View>

          <View style={verifyEmailStyles.inputGroup}>
            <Text style={verifyEmailStyles.label}>Verification Code</Text>
            <View style={verifyEmailStyles.inputWrapper}>
              <Feather name="key" size={20} color="#64748B" />
              <TextInput
                value={code}
                onChangeText={(text) => setCode(text.slice(0, 6))}
                keyboardType="numeric"
                placeholder="000000"
                maxLength={6}
                style={[verifyEmailStyles.input, { letterSpacing: 4 }]}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && code.length !== 6 && (
              <Text style={verifyEmailStyles.errorText}>Code must be 6 digits</Text>
            )}
          </View>

          <View style={verifyEmailStyles.hintBox}>
            <Text style={verifyEmailStyles.hintText}>
              Check your email inbox (and spam folder) for the verification code.
            </Text>
          </View>

          <TouchableOpacity
            style={[
              verifyEmailStyles.verifyButton,
              { opacity: isSubmitting ? 0.6 : 1 },
            ]}
            onPress={handleVerify}
            disabled={isSubmitting}
          >
            <Text style={verifyEmailStyles.buttonLabel}>
              {isSubmitting ? 'Verifying...' : 'Verify Email'}
            </Text>
          </TouchableOpacity>
        </View>

        <View style={verifyEmailStyles.footer}>
          <Text style={verifyEmailStyles.footerText}>Didn't receive code? </Text>
          <TouchableOpacity onPress={() => Toast.show({ type: 'info', text1: 'Resend coming soon' })}>
            <Text style={verifyEmailStyles.footerLink}>Resend</Text>
          </TouchableOpacity>
        </View>
      </View>
    </ScrollView>
  );
}