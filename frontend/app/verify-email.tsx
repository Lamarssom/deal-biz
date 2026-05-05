import React, { useState } from 'react';
import {
  ScrollView,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Feather } from '@expo/vector-icons';
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
      Alert.alert(
        'Validation Error',
        'Please enter a valid email and 6-digit code.'
      );
      return;
    }

    setIsSubmitting(true);
    try {
      const response = await apiService.verifyEmail(email, code);
      Alert.alert('Success', response.message || 'Email verified successfully!');
      router.replace('/home');
    } catch (error: any) {
      const errorMessage =
        error?.message || 'Verification failed. Please try again.';
      Alert.alert('Error', errorMessage);
      console.log('Verification error:', error);
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
        {/* Header */}
        <View style={verifyEmailStyles.headerContainer}>
          <Logo width={150} height={60} />
          <Text style={verifyEmailStyles.title}>Verify Your Email</Text>
          <Text style={verifyEmailStyles.subtitle}>
            We sent a 6-digit code to your email
          </Text>
          <Text style={verifyEmailStyles.caption}>{email}</Text>
        </View>

        {/* Form */}
        <View style={{ marginBottom: 24 }}>
          {/* Email Field */}
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

          {/* Code Field */}
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

          {/* Hint */}
          <View style={verifyEmailStyles.hintBox}>
            <Text style={verifyEmailStyles.hintText}>
              Check your email inbox (and spam folder) for the verification code.
            </Text>
          </View>

          {/* Verify Button */}
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

        {/* Footer */}
        <View style={verifyEmailStyles.footer}>
          <Text style={verifyEmailStyles.footerText}>Didn't receive code? </Text>
          <TouchableOpacity onPress={() => Alert.alert('Resend code feature coming soon')}>
            <Text style={verifyEmailStyles.footerLink}>Resend</Text>
          </TouchableOpacity>
        </View>
      </View>
    </ScrollView>
  );
}
