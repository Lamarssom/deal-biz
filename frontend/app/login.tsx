import React, { useState, useEffect } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity, 
  KeyboardAvoidingView, 
  Platform 
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Feather, FontAwesome } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';
import Logo from '../components/Logo';
import { loginStyles } from '../styles/login.styles';
import { useAuth } from '../context/AuthContext';

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function LoginScreen() {
  const router = useRouter();
  const { email: paramEmail } = useLocalSearchParams<{ email: string }>();
  
  const [email, setEmail] = useState(paramEmail || '');
  const [password, setPassword] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [isLoggingIn, setIsLoggingIn] = useState(false);

  const { login } = useAuth();

  useEffect(() => {
    if (paramEmail) setEmail(paramEmail);
  }, [paramEmail]);

  const handleLogin = async () => {
    setSubmitted(true);
    
    if (!emailRegex.test(email) || password.length < 6) {
      Toast.show({ 
        type: 'error', 
        text1: 'Validation Error', 
        text2: 'Please enter valid email and password' 
      });
      return;
    }

    const normalizedEmail = email.trim().toLowerCase();

    setIsLoggingIn(true);
    try {
      await login(normalizedEmail, password);
      Toast.show({ type: 'success', text1: 'Login Successful!' });
      router.replace('/(tabs)/home');
    } catch (error: any) {
      Toast.show({ 
        type: 'error', 
        text1: 'Login Failed', 
        text2: error?.message || 'Invalid credentials' 
      });
    } finally {
      setIsLoggingIn(false);
    }
  };

  const handleForgotPassword = () => {
    router.push('/forgot-password');
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={loginStyles.container}
    >
      <ScrollView 
        style={{ flex: 1 }}
        contentContainerStyle={loginStyles.scrollContent}
        keyboardShouldPersistTaps="handled"
      >
        <View style={{ flex: 1, justifyContent: 'space-between' }}>
          
          <View style={loginStyles.logoContainer}>
            <Logo width={240} height={100} />
          </View>

          <Text style={loginStyles.title}>Welcome Back</Text>
          <Text style={loginStyles.subtitle}>Login to your account</Text>

          <View style={loginStyles.formCard}>
            <View style={loginStyles.inputContainer}>
              <Text style={loginStyles.label}>Email</Text>
              <View style={loginStyles.inputWrapper}>
                <Feather name="mail" size={20} color="#64748B" />
                <TextInput
                  value={email}
                  onChangeText={setEmail}
                  keyboardType="email-address"
                  autoCapitalize="none"
                  placeholder="you@example.com"
                  style={loginStyles.input}
                  placeholderTextColor="#94A3B8"
                />
              </View>
              {submitted && !emailRegex.test(email) && (
                <Text style={{ color: '#EF4444', fontSize: 12, marginTop: 6 }}>
                  Please enter a valid email
                </Text>
              )}
            </View>

            <View style={loginStyles.inputContainer}>
              <Text style={loginStyles.label}>Password</Text>
              
              <View style={loginStyles.inputWrapper}>
                <Feather name="lock" size={20} color="#64748B" />
                <TextInput
                  value={password}
                  onChangeText={setPassword}
                  secureTextEntry={!showPassword}
                  placeholder="Minimum 6 characters"
                  style={loginStyles.input}
                  placeholderTextColor="#94A3B8"
                />
                <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
                  <Feather name={showPassword ? "eye" : "eye-off"} size={20} color="#64748B" />
                </TouchableOpacity>
              </View>

              {submitted && password.length < 6 && (
                <Text style={{ color: '#EF4444', fontSize: 12, marginTop: 6 }}>
                  Password must be at least 6 characters
                </Text>
              )}

              <TouchableOpacity
                style={{ alignSelf: 'flex-end', marginTop: 8 }}
                onPress={handleForgotPassword}
              >
                <Text style={loginStyles.forgotPassword}>
                  Forgot password?
                </Text>
              </TouchableOpacity>
            </View>

            <TouchableOpacity 
              style={[loginStyles.loginButton, isLoggingIn && { opacity: 0.7 }]} 
              onPress={handleLogin}
              disabled={isLoggingIn}
            >
              <Text style={loginStyles.loginButtonText}>
                {isLoggingIn ? 'Logging in...' : 'Login'}
              </Text>
            </TouchableOpacity>

            <View style={{ marginTop: 32, alignItems: 'center' }}>
              <Text style={loginStyles.orText}>Or login with</Text>
              <View style={loginStyles.socialContainer}>
                <TouchableOpacity style={loginStyles.socialButton}>
                  <FontAwesome name="google" size={22} color="#DB4437" />
                </TouchableOpacity>
                <TouchableOpacity style={loginStyles.socialButton}>
                  <FontAwesome name="apple" size={22} color="#000000" />
                </TouchableOpacity>
              </View>
            </View>
          </View>

          <View style={loginStyles.signupContainer}>
            <Text style={loginStyles.signupText}>Don’t have an account? </Text>
            <Text style={loginStyles.signupLink} onPress={() => router.push('/signup')}>
              Sign up
            </Text>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}