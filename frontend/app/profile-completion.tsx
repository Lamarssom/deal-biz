import React, { useState } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity, 
  KeyboardAvoidingView, 
  Platform,
  Alert
} from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';
import { useAuth } from '../context/AuthContext';
import { apiService } from '../services/api';

export default function ProfileCompletion() {
  const router = useRouter();
  const { user, login } = useAuth();

  const [name, setName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleCompleteProfile = async () => {
    if (!name.trim() || !phoneNumber.trim()) {
      Toast.show({ type: 'error', text1: 'Please fill all fields' });
      return;
    }

    setIsSubmitting(true);
    try {
      // Update phone and name
      await apiService.updatePhoneNumber(phoneNumber);
      
      // You can also add a name update endpoint later if needed

      Toast.show({ 
        type: 'success', 
        text1: 'Profile Completed!', 
        text2: 'Welcome to Deal Biz' 
      });

      router.replace('/(tabs)/home');
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Failed', text2: error?.message });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1, backgroundColor: '#F8FAFC' }}
    >
      <ScrollView contentContainerStyle={{ flexGrow: 1, padding: 24, justifyContent: 'center' }}>
        <View style={{ alignItems: 'center', marginBottom: 40 }}>
          <Feather name="user-check" size={80} color="#1C8EDA" />
          <Text style={{ fontSize: 28, fontWeight: '700', marginTop: 20, textAlign: 'center' }}>
            Complete Your Profile
          </Text>
          <Text style={{ fontSize: 16, color: '#64748B', textAlign: 'center', marginTop: 8 }}>
            Just a few more details to get started
          </Text>
        </View>

        <View style={{ backgroundColor: '#fff', borderRadius: 20, padding: 24, gap: 20 }}>
          <View>
            <Text style={{ fontWeight: '600', marginBottom: 8 }}>Full Name</Text>
            <TextInput
              value={name}
              onChangeText={setName}
              placeholder="Enter your full name"
              style={{
                borderWidth: 1,
                borderColor: '#E2E8F0',
                borderRadius: 12,
                padding: 16,
                fontSize: 16
              }}
            />
          </View>

          <View>
            <Text style={{ fontWeight: '600', marginBottom: 8 }}>Phone Number</Text>
            <TextInput
              value={phoneNumber}
              onChangeText={setPhoneNumber}
              placeholder="+234 801 234 5678"
              keyboardType="phone-pad"
              style={{
                borderWidth: 1,
                borderColor: '#E2E8F0',
                borderRadius: 12,
                padding: 16,
                fontSize: 16
              }}
            />
          </View>

          <TouchableOpacity 
            onPress={handleCompleteProfile}
            disabled={isSubmitting}
            style={{
              backgroundColor: '#1C8EDA',
              padding: 18,
              borderRadius: 999,
              alignItems: 'center',
              marginTop: 20
            }}
          >
            <Text style={{ color: '#fff', fontWeight: '600', fontSize: 17 }}>
              {isSubmitting ? 'Saving...' : 'Complete Profile'}
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}