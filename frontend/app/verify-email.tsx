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
      Alert.alert('Success', response.message || 'Email verified successfully!', [
        {
          text: 'Continue to Login',
          onPress: () => {
            router.push({
              pathname: '/login',
              params: { email },
            });
          },
        },
      ]);
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
      style={{
        flex: 1,
        backgroundColor: '#FFFFFF',
        paddingHorizontal: 20,
      }}
      contentContainerStyle={{
        justifyContent: 'center',
        minHeight: '100%',
      }}
      keyboardShouldPersistTaps="handled"
    >
      <View>
        {/* Header */}
        <View style={{ alignItems: 'center', marginBottom: 32 }}>
          <Logo width={150} height={60} />
          <Text
            style={{
              fontSize: 24,
              fontWeight: '700',
              color: '#1E293B',
              marginTop: 16,
              marginBottom: 8,
            }}
          >
            Verify Your Email
          </Text>
          <Text
            style={{
              fontSize: 14,
              color: '#64748B',
              textAlign: 'center',
              marginBottom: 8,
            }}
          >
            We sent a 6-digit code to your email
          </Text>
          <Text
            style={{
              fontSize: 12,
              color: '#94A3B8',
              textAlign: 'center',
            }}
          >
            {email}
          </Text>
        </View>

        {/* Form */}
        <View style={{ marginBottom: 24 }}>
          {/* Email Field */}
          <View style={{ marginBottom: 16 }}>
            <Text
              style={{
                fontSize: 14,
                fontWeight: '500',
                color: '#1E293B',
                marginBottom: 8,
              }}
            >
              Email Address
            </Text>
            <View
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                backgroundColor: '#F1F5F9',
                borderRadius: 8,
                paddingHorizontal: 12,
                paddingVertical: 12,
                borderWidth: 1,
                borderColor: '#E2E8F0',
              }}
            >
              <Feather name="mail" size={20} color="#64748B" />
              <TextInput
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                placeholder="your@email.com"
                style={{
                  flex: 1,
                  marginLeft: 12,
                  color: '#1E293B',
                  fontSize: 14,
                }}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !email.trim() && (
              <Text
                style={{
                  color: '#EF4444',
                  fontSize: 12,
                  marginTop: 4,
                }}
              >
                Email is required
              </Text>
            )}
          </View>

          {/* Code Field */}
          <View style={{ marginBottom: 16 }}>
            <Text
              style={{
                fontSize: 14,
                fontWeight: '500',
                color: '#1E293B',
                marginBottom: 8,
              }}
            >
              Verification Code
            </Text>
            <View
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                backgroundColor: '#F1F5F9',
                borderRadius: 8,
                paddingHorizontal: 12,
                paddingVertical: 12,
                borderWidth: 1,
                borderColor: '#E2E8F0',
              }}
            >
              <Feather name="key" size={20} color="#64748B" />
              <TextInput
                value={code}
                onChangeText={(text) => setCode(text.slice(0, 6))}
                keyboardType="numeric"
                placeholder="000000"
                maxLength={6}
                style={{
                  flex: 1,
                  marginLeft: 12,
                  color: '#1E293B',
                  fontSize: 14,
                  letterSpacing: 4,
                }}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && code.length !== 6 && (
              <Text
                style={{
                  color: '#EF4444',
                  fontSize: 12,
                  marginTop: 4,
                }}
              >
                Code must be 6 digits
              </Text>
            )}
          </View>

          {/* Hint */}
          <View
            style={{
              backgroundColor: '#F0F9FF',
              borderLeftWidth: 4,
              borderLeftColor: '#0EA5E9',
              padding: 12,
              borderRadius: 4,
              marginBottom: 24,
            }}
          >
            <Text
              style={{
                fontSize: 12,
                color: '#0369A1',
              }}
            >
              Check your email inbox (and spam folder) for the verification code.
            </Text>
          </View>

          {/* Verify Button */}
          <TouchableOpacity
            style={{
              backgroundColor: '#1C8EDA',
              borderRadius: 8,
              paddingVertical: 14,
              alignItems: 'center',
              opacity: isSubmitting ? 0.6 : 1,
            }}
            onPress={handleVerify}
            disabled={isSubmitting}
          >
            <Text
              style={{
                color: '#FFFFFF',
                fontSize: 16,
                fontWeight: '600',
              }}
            >
              {isSubmitting ? 'Verifying...' : 'Verify Email'}
            </Text>
          </TouchableOpacity>
        </View>

        {/* Footer */}
        <View
          style={{
            flexDirection: 'row',
            justifyContent: 'center',
            paddingTop: 16,
            borderTopWidth: 1,
            borderTopColor: '#E2E8F0',
          }}
        >
          <Text
            style={{
              fontSize: 14,
              color: '#64748B',
            }}
          >
            Didn't receive code?{' '}
          </Text>
          <TouchableOpacity onPress={() => Alert.alert('Resend code feature coming soon')}>
            <Text
              style={{
                fontSize: 14,
                color: '#1C8EDA',
                fontWeight: '600',
              }}
            >
              Resend
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </ScrollView>
  );
}
