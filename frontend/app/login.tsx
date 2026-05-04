import React, { useState } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity, 
  KeyboardAvoidingView, 
  Platform 
} from 'react-native';
import { useRouter } from 'expo-router';
import { Feather, FontAwesome } from '@expo/vector-icons';
import Logo from '../components/Logo';
import { loginStyles } from '../styles/login.styles';

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function LoginScreen() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = () => {
    setSubmitted(true);
    if (!emailRegex.test(email) || password.length < 6) {
      return;
    }
    router.replace('/welcome');
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
          
          {/* Logo */}
          <View style={loginStyles.logoContainer}>
            <Logo width={240} height={100} />
          </View>

          {/* Title */}
          <Text style={loginStyles.title}>Welcome Back</Text>
          <Text style={loginStyles.subtitle}>Login to your account</Text>

          {/* Form Card */}
          <View style={loginStyles.formCard}>
            {/* Email */}
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

            {/* Password */}
            <View style={loginStyles.inputContainer}>
              <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 }}>
                <Text style={loginStyles.label}>Password</Text>
                <Text 
                  style={loginStyles.forgotPassword} 
                  onPress={() => alert('Forgot password flow coming soon')}
                >
                  Forgot password?
                </Text>
              </View>
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
            </View>

            {/* Login Button */}
            <TouchableOpacity style={loginStyles.loginButton} onPress={handleLogin}>
              <Text style={loginStyles.loginButtonText}>Login</Text>
            </TouchableOpacity>

            {/* Social Login */}
            <View style={{ marginTop: 32, alignItems: 'center' }}>
              <Text style={loginStyles.orText}>Or login with</Text>
              
              <View style={loginStyles.socialContainer}>
                <TouchableOpacity style={loginStyles.socialButton}>
                  <FontAwesome name="facebook" size={22} color="#3B5998" />
                </TouchableOpacity>
                <TouchableOpacity style={loginStyles.socialButton}>
                  <FontAwesome name="google" size={22} color="#DB4437" />
                </TouchableOpacity>
                <TouchableOpacity style={loginStyles.socialButton}>
                  <FontAwesome name="apple" size={22} color="#000000" />
                </TouchableOpacity>
              </View>
            </View>
          </View>

          {/* Sign Up Link */}
          <View style={loginStyles.signupContainer}>
            <Text style={loginStyles.signupText}>Don’t have an account? </Text>
            <Text 
              style={loginStyles.signupLink} 
              onPress={() => router.push('/signup')}
            >
              Sign up
            </Text>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}