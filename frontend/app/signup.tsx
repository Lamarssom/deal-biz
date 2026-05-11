import React, { useState, useEffect } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity,
  Alert 
} from 'react-native';
import { useRouter } from 'expo-router';
import { Feather, FontAwesome } from '@expo/vector-icons';
import Logo from '../components/Logo';
import { Dropdown } from '../components/Dropdown';
import { signupStyles } from '../styles/signup.styles';
import { apiService, State as StateType, LGA } from '../services/api';
import { useAuth } from '../context/AuthContext';

const MAPBOX_TOKEN = process.env.EXPO_PUBLIC_MAPBOX_TOKEN || '';
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const categories = [
  { id: 1, label: "Restaurant & Food", value: "Restaurant & Food" },
  { id: 2, label: "Fashion & Clothing", value: "Fashion & Clothing" },
  { id: 3, label: "Supermarket & Groceries", value: "Supermarket & Groceries" },
  { id: 4, label: "Pharmacy & Health", value: "Pharmacy & Health" },
  { id: 5, label: "Electronics", value: "Electronics" },
  { id: 6, label: "Beauty & Salon", value: "Beauty & Salon" },
  { id: 7, label: "Services", value: "Services" },
  { id: 8, label: "Others", value: "Others" },
];

export default function SignupScreen() {
  const router = useRouter();
  const { register } = useAuth();

  const [role, setRole] = useState<'customer' | 'merchant' | null>(null);
  
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  // Merchant fields
  const [businessName, setBusinessName] = useState('');
  const [category, setCategory] = useState('');
  const [state, setState] = useState('');
  const [lga, setLga] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [address, setAddress] = useState('');
  const [latitude, setLatitude] = useState<number | null>(null);
  const [longitude, setLongitude] = useState<number | null>(null);

  const [suggestions, setSuggestions] = useState<any[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);

  // Location data
  const [states, setStates] = useState<StateType[]>([]);
  const [lgas, setLgas] = useState<LGA[]>([]);
  const [isLoadingStates, setIsLoadingStates] = useState(false);
  const [isLoadingLgas, setIsLoadingLgas] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const [submitted, setSubmitted] = useState(false);

  useEffect(() => {
    if (role === 'merchant' && states.length === 0) {
      fetchStates();
    }
  }, [role]);

  useEffect(() => {
    if (state && role === 'merchant') {
      fetchLGAs(state);
    } else {
      setLga('');
      setLgas([]);
    }
  }, [state]);

  const fetchStates = async () => {
    setIsLoadingStates(true);
    try {
      const data = await apiService.getStates();
      setStates(data);
    } catch (error) {
      Alert.alert('Error', 'Failed to load states. Please try again.');
    } finally {
      setIsLoadingStates(false);
    }
  };

  const fetchLGAs = async (selectedState: string) => {
    setIsLoadingLgas(true);
    try {
      const data = await apiService.getLGAs(selectedState);
      setLgas(data);
    } catch (error) {
      Alert.alert('Error', 'Failed to load LGAs. Please try again.');
    } finally {
      setIsLoadingLgas(false);
    }
  };

  // Mapbox Address Autocomplete
  const searchAddress = async (text: string) => {
    setAddress(text);
    if (text.length < 3) {
      setSuggestions([]);
      setShowSuggestions(false);
      return;
    }

    try {
      const res = await fetch(
        `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(text)}.json?` +
        `access_token=${MAPBOX_TOKEN}&` +
        `country=NG&` +
        `types=address,place,locality&` +
        `proximity=3.3792,6.5244&` +    
        `limit=8`
      );
      const data = await res.json();
      setSuggestions(data.features || []);
      setShowSuggestions(true);
    } catch (e) {
      console.log('Mapbox search error', e);
    }
  };

  const selectSuggestion = (feature: any) => {
    setAddress(feature.place_name);
    setLatitude(feature.center[1]);
    setLongitude(feature.center[0]);
    setSuggestions([]);
    setShowSuggestions(false);
  };

  const handleSignup = async () => {
    setSubmitted(true);

    if (!role || !name.trim() || !emailRegex.test(email) || password.length < 6 || password !== confirmPassword) {
      Alert.alert("Validation Error", "Please fill all required fields correctly.");
      return;
    }

    if (role === 'merchant' && (!businessName.trim() || !category || !state || !lga)) {
      Alert.alert("Validation Error", "Please fill all merchant information.");
      return;
    }

    setIsSubmitting(true);
    try {
      const payload = {
        email,
        password,
        name,
        role: role.toUpperCase() as 'MERCHANT' | 'CUSTOMER',
        ...(role === 'merchant' && {
          businessName,
          category,
          businessLGA: lga,
          phoneNumber: phoneNumber || undefined,
          address: address || undefined,
          latitude: latitude || undefined,
          longitude: longitude || undefined,
        }),
      };

      const response = await register(payload);

      if (response?.user) {
        Alert.alert("Success", "Account created successfully!", [
          { text: "Continue", onPress: () => router.replace('/home') }
        ]);
      } else if (response?.message) {
        router.push(`/verify-email?email=${encodeURIComponent(email)}`);
        Alert.alert("Check Your Email", response.message);
      }
    } catch (error: any) {
      const errorMessage = error?.message || 'Registration failed. Please try again.';
      Alert.alert("Error", errorMessage);
      console.log('Registration error:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <ScrollView
      style={signupStyles.container}
      contentContainerStyle={signupStyles.scrollContent}
      keyboardShouldPersistTaps="handled"
    >
      <View style={{ flex: 1, justifyContent: 'space-between' }}>
        
        {/* Header */}
        <View style={signupStyles.headerContainer}>
          <Logo width={200} height={80} />
          <Text style={signupStyles.title}>Create Account</Text>
          <Text style={signupStyles.subtitle}>
            Sign up to unlock local deals, merchant tools, and a tailored dashboard.
          </Text>
        </View>

        <View style={signupStyles.formCard}>
          
          {/* Role Selection */}
          <Text style={signupStyles.label}>I want to sign up as</Text>
          <View style={signupStyles.roleContainer}>
            
            <TouchableOpacity 
              style={[signupStyles.roleCard, role === 'customer' && signupStyles.roleCardSelected]}
              onPress={() => setRole('customer')}
            >
              <Feather name="user" size={32} color={role === 'customer' ? "#1C8EDA" : "#64748B"} style={signupStyles.roleIcon} />
              <Text style={signupStyles.roleTitle}>Customer</Text>
            </TouchableOpacity>

            <TouchableOpacity 
              style={[signupStyles.roleCard, role === 'merchant' && signupStyles.roleCardSelected]}
              onPress={() => setRole('merchant')}
            >
              <Feather name="briefcase" size={32} color={role === 'merchant' ? "#1C8EDA" : "#64748B"} style={signupStyles.roleIcon} />
              <Text style={signupStyles.roleTitle}>Merchant</Text>
            </TouchableOpacity>

          </View>

          {/* Common Fields */}
          <View style={signupStyles.inputGroup}>
            <Text style={signupStyles.label}>Full Name</Text>
            <View style={signupStyles.inputWrapper}>
              <Feather name="user" size={20} color="#64748B" />
              <TextInput
                value={name}
                onChangeText={setName}
                placeholder="Your full name"
                style={signupStyles.input}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !name.trim() && <Text style={{color: '#EF4444', fontSize: 12, marginTop: 4}}>Name is required</Text>}
          </View>

          {/* Merchant Only Fields */}
          {role === 'merchant' && (
            <>
              <View style={signupStyles.inputGroup}>
                <Text style={signupStyles.label}>Business Name</Text>
                <View style={signupStyles.inputWrapper}>
                  <Feather name="briefcase" size={20} color="#64748B" />
                  <TextInput
                    value={businessName}
                    onChangeText={setBusinessName}
                    placeholder="Business name"
                    style={signupStyles.input}
                    placeholderTextColor="#94A3B8"
                  />
                </View>
              </View>

              <View style={signupStyles.inputGroup}>
                <Text style={signupStyles.label}>Phone Number</Text>
                <View style={signupStyles.inputWrapper}>
                  <Feather name="phone" size={20} color="#64748B" />
                  <TextInput
                    value={phoneNumber}
                    onChangeText={setPhoneNumber}
                    placeholder="+234 801 234 5678"
                    keyboardType="phone-pad"
                    style={signupStyles.input}
                    placeholderTextColor="#94A3B8"
                  />
                </View>
              </View>
              <View style={signupStyles.inputGroup}>
                <Text style={signupStyles.label}>Business Address</Text>
                <View style={signupStyles.inputWrapper}>
                  <Feather name="map-pin" size={20} color="#64748B" />
                  <TextInput
                    value={address}
                    onChangeText={searchAddress}
                    placeholder="Start typing your address..."
                    style={signupStyles.input}
                    placeholderTextColor="#94A3B8"
                  />
                </View>

                {/* Suggestions Dropdown */}
                {showSuggestions && suggestions.length > 0 && (
                  <View style={{ 
                    backgroundColor: '#fff', 
                    borderRadius: 12, 
                    marginTop: 4, 
                    maxHeight: 220, 
                    borderWidth: 1,
                    borderColor: '#E2E8F0',
                    shadowColor: '#000',
                    shadowOffset: { width: 0, height: 2 },
                    shadowOpacity: 0.1,
                    elevation: 3
                  }}>
                    {suggestions.map((item, index) => (
                      <TouchableOpacity 
                        key={index}
                        style={{ padding: 14, borderBottomWidth: 1, borderBottomColor: '#F1F5F9' }}
                        onPress={() => selectSuggestion(item)}
                      >
                        <Text style={{ fontSize: 15 }}>{item.place_name}</Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                )}
              </View>
              <View style={signupStyles.inputGroup}>
                <Dropdown
                  label="Business Category"
                  options={categories}
                  value={category}
                  onSelect={setCategory}
                  placeholder="Select category"
                  icon="tag"
                />
              </View>

              <View style={signupStyles.inputGroup}>
                <Dropdown
                  label="State"
                  options={states.map((s) => ({
                    id: s.id,
                    label: s.state,
                    value: s.state,
                  }))}
                  value={state}
                  onSelect={setState}
                  placeholder="Select state"
                  icon="map-pin"
                  isLoading={isLoadingStates}
                />
              </View>

              <View style={signupStyles.inputGroup}>
                <Dropdown
                  label="LGA"
                  options={lgas.map((l) => ({
                    id: l.id,
                    label: l.lga,
                    value: l.lga,
                  }))}
                  value={lga}
                  onSelect={setLga}
                  placeholder="Select LGA"
                  icon="map"
                  isLoading={isLoadingLgas}
                />
              </View>
            </>
          )}

          {/* Email */}
          <View style={signupStyles.inputGroup}>
            <Text style={signupStyles.label}>Email Address</Text>
            <View style={signupStyles.inputWrapper}>
              <Feather name="mail" size={20} color="#64748B" />
              <TextInput
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                placeholder="you@example.com"
                style={signupStyles.input}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && !emailRegex.test(email) && <Text style={{color: '#EF4444', fontSize: 12, marginTop: 4}}>Valid email is required</Text>}
          </View>

          {/* Password */}
          <View style={signupStyles.inputGroup}>
            <Text style={signupStyles.label}>Password</Text>
            <View style={signupStyles.inputWrapper}>
              <Feather name="lock" size={20} color="#64748B" />
              <TextInput
                value={password}
                onChangeText={setPassword}
                secureTextEntry
                placeholder="Minimum 6 characters"
                style={signupStyles.input}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && password.length < 6 && <Text style={{color: '#EF4444', fontSize: 12, marginTop: 4}}>Password must be at least 6 characters</Text>}
          </View>

          {/* Confirm Password */}
          <View style={signupStyles.inputGroup}>
            <Text style={signupStyles.label}>Confirm Password</Text>
            <View style={signupStyles.inputWrapper}>
              <Feather name="repeat" size={20} color="#64748B" />
              <TextInput
                value={confirmPassword}
                onChangeText={setConfirmPassword}
                secureTextEntry
                placeholder="Repeat your password"
                style={signupStyles.input}
                placeholderTextColor="#94A3B8"
              />
            </View>
            {submitted && password !== confirmPassword && <Text style={{color: '#EF4444', fontSize: 12, marginTop: 4}}>Passwords do not match</Text>}
          </View>

          {/* Create Account Button */}
          <TouchableOpacity 
            style={[signupStyles.createButton, isSubmitting && { opacity: 0.6 }]} 
            onPress={handleSignup}
            disabled={isSubmitting}
          >
            <Text style={signupStyles.createButtonText}>
              {isSubmitting ? 'Creating account...' : 'Create account'}
            </Text>
          </TouchableOpacity>

          {/* Social Signup */}
          <Text style={signupStyles.orText}>Or sign up with</Text>
          
          <View style={signupStyles.socialContainer}>
            <TouchableOpacity style={signupStyles.socialButton}>
              <FontAwesome name="facebook" size={20} color="#3B5998" />
            </TouchableOpacity>
            <TouchableOpacity style={signupStyles.socialButton}>
              <FontAwesome name="google" size={20} color="#DB4437" />
            </TouchableOpacity>
            <TouchableOpacity style={signupStyles.socialButton}>
              <FontAwesome name="apple" size={20} color="#000000" />
            </TouchableOpacity>
          </View>
        </View>

        {/* Footer */}
        <View style={signupStyles.footer}>
          <Text style={signupStyles.footerText}>Already have an account? </Text>
          <Text style={signupStyles.loginLink} onPress={() => router.push('/login')}>
            Log in
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}