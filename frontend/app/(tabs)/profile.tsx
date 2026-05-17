import React, { useState, useEffect } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  Modal, 
  TextInput, 
  Switch, 
  Alert,
  KeyboardAvoidingView,
  Platform 
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import { useAuth } from '../../context/AuthContext';
import { apiService } from '../../services/api';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';
import AsyncStorage from '@react-native-async-storage/async-storage';

export default function ProfileScreen() {
  const { user: authUser, logout } = useAuth();
  const router = useRouter();

  // Local fresh profile data
  const [profile, setProfile] = useState<any>(null);

  // Modals
  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [showPhoneModal, setShowPhoneModal] = useState(false);

  // Password form
  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passwordLoading, setPasswordLoading] = useState(false);

  const [newPhoneNumber, setNewPhoneNumber] = useState('');
  const [phoneLoading, setPhoneLoading] = useState(false);

  const [notificationsEnabled, setNotificationsEnabled] = useState(true);

  // Fetch fresh profile (for Current Phone Number display)
  const loadProfile = async () => {
    try {
      const freshProfile = await apiService.getProfile();
      setProfile(freshProfile);
    } catch (error) {
      console.log('Failed to load fresh profile', error);
    }
  };

  // Load fresh profile every time the tab is focused
  useFocusEffect(
    React.useCallback(() => {
      if (authUser) {
        loadProfile();
      }
    }, [authUser])
  );

  const handleLogout = () => {
    Alert.alert('Logout', 'Are you sure you want to log out?', [
      { text: 'Cancel', style: 'cancel' },
      { 
        text: 'Logout', 
        style: 'destructive', 
        onPress: async () => {
          await logout();
          router.replace('/login');
        }
      },
    ]);
  };

  const handleChangePassword = async () => {
    if (!oldPassword || !newPassword || !confirmPassword) {
      Toast.show({ type: 'error', text1: 'All fields are required' });
      return;
    }
    if (newPassword.length < 6) {
      Toast.show({ type: 'error', text1: 'New password must be at least 6 characters' });
      return;
    }
    if (newPassword !== confirmPassword) {
      Toast.show({ type: 'error', text1: 'Passwords do not match' });
      return;
    }

    setPasswordLoading(true);
    try {
      await apiService.changePassword(oldPassword, newPassword);
      Toast.show({ type: 'success', text1: 'Password changed successfully' });
      setShowPasswordModal(false);
      setOldPassword(''); 
      setNewPassword(''); 
      setConfirmPassword('');
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Failed to change password', text2: error.message });
    } finally {
      setPasswordLoading(false);
    }
  };

  const handleChangePhone = async () => {
    if (!newPhoneNumber || newPhoneNumber.length < 10) {
      Toast.show({ type: 'error', text1: 'Please enter a valid phone number' });
      return;
    }

    setPhoneLoading(true);
    try {
      await apiService.updatePhoneNumber(newPhoneNumber);
      Toast.show({ type: 'success', text1: 'Phone number updated successfully' });
      
      // Refresh profile so "Current" updates
      await loadProfile();
      
      setShowPhoneModal(false);
      setNewPhoneNumber(''); // Clear the field after successful update
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Failed to update phone number', text2: error.message });
    } finally {
      setPhoneLoading(false);
    }
  };

  const toggleNotifications = async (value: boolean) => {
    setNotificationsEnabled(value);
    await AsyncStorage.setItem('@deal_biz_notifications', JSON.stringify(value));
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#F8FAFC' }}>
      <ScrollView style={{ flex: 1 }}>
        {/* Header */}
        <View style={{ padding: 24, backgroundColor: '#1C8EDA', alignItems: 'center' }}>
          <Feather name="user" size={80} color="#fff" />
          <Text style={{ color: '#fff', fontSize: 22, fontWeight: '700', marginTop: 12 }}>
            {profile?.email || authUser?.email || 'Welcome'}
          </Text>
          {profile?.phoneNumber && (
            <Text style={{ color: '#fff', opacity: 0.9, marginTop: 4 }}>
              {profile.phoneNumber}
            </Text>
          )}
        </View>

        <View style={{ padding: 20 }}>
          {/* Change Password */}
          <TouchableOpacity 
            style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 16, borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}
            onPress={() => setShowPasswordModal(true)}
          >
            <Feather name="lock" size={24} color="#1C8EDA" />
            <Text style={{ flex: 1, marginLeft: 16, fontSize: 17 }}>Change Password</Text>
            <Feather name="chevron-right" size={24} color="#64748B" />
          </TouchableOpacity>

          {/* Change Phone */}
          <TouchableOpacity 
            style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 16, borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}
            onPress={() => {
              setNewPhoneNumber('');        // ← Ensure field starts empty
              setShowPhoneModal(true);
            }}
          >
            <Feather name="phone" size={24} color="#1C8EDA" />
            <Text style={{ flex: 1, marginLeft: 16, fontSize: 17 }}>Change Phone Number</Text>
            <Feather name="chevron-right" size={24} color="#64748B" />
          </TouchableOpacity>

          {/* Notifications */}
          <View style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 16, borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}>
            <Feather name="bell" size={24} color="#1C8EDA" />
            <Text style={{ flex: 1, marginLeft: 16, fontSize: 17 }}>Push Notifications</Text>
            <Switch 
              value={notificationsEnabled} 
              onValueChange={toggleNotifications}
              trackColor={{ false: '#E2E8F0', true: '#1C8EDA' }}
            />
          </View>

          {/* Logout */}
          <TouchableOpacity 
            onPress={handleLogout}
            style={{ marginTop: 40, backgroundColor: '#EF4444', padding: 16, borderRadius: 999, alignItems: 'center' }}
          >
            <Text style={{ color: '#fff', fontSize: 17, fontWeight: '600' }}>Logout</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>

      {/* Password Modal - unchanged */}
      <Modal visible={showPasswordModal} transparent animationType="slide">
        <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={{ flex: 1, justifyContent: 'flex-end' }}>
          <View style={{ backgroundColor: '#fff', borderTopLeftRadius: 24, borderTopRightRadius: 24, padding: 24 }}>
            <Text style={{ fontSize: 22, fontWeight: '700', textAlign: 'center', marginBottom: 20 }}>Change Password</Text>

            <TextInput
              style={{ borderWidth: 1, borderColor: '#E2E8F0', borderRadius: 12, padding: 14, marginBottom: 12 }}
              placeholder="Current Password"
              secureTextEntry
              value={oldPassword}
              onChangeText={setOldPassword}
            />
            <TextInput
              style={{ borderWidth: 1, borderColor: '#E2E8F0', borderRadius: 12, padding: 14, marginBottom: 12 }}
              placeholder="New Password"
              secureTextEntry
              value={newPassword}
              onChangeText={setNewPassword}
            />
            <TextInput
              style={{ borderWidth: 1, borderColor: '#E2E8F0', borderRadius: 12, padding: 14, marginBottom: 24 }}
              placeholder="Confirm New Password"
              secureTextEntry
              value={confirmPassword}
              onChangeText={setConfirmPassword}
            />

            <TouchableOpacity 
              onPress={handleChangePassword}
              disabled={passwordLoading}
              style={{ backgroundColor: '#1C8EDA', padding: 16, borderRadius: 999, alignItems: 'center' }}
            >
              <Text style={{ color: '#fff', fontWeight: '600', fontSize: 17 }}>
                {passwordLoading ? 'Updating...' : 'Update Password'}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity 
              onPress={() => setShowPasswordModal(false)}
              style={{ marginTop: 16, alignItems: 'center' }}
            >
              <Text style={{ color: '#64748B' }}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </KeyboardAvoidingView>
      </Modal>

      {/* ==================== CHANGE PHONE MODAL ==================== */}
      <Modal visible={showPhoneModal} transparent animationType="slide">
        <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={{ flex: 1, justifyContent: 'flex-end' }}>
          <View style={{ backgroundColor: '#fff', borderTopLeftRadius: 24, borderTopRightRadius: 24, padding: 24 }}>
            <Text style={{ fontSize: 22, fontWeight: '700', textAlign: 'center', marginBottom: 24 }}>Change Phone Number</Text>

            {/* Current Phone Number */}
            <Text style={{ fontSize: 15, color: '#64748B', marginBottom: 6 }}>Current Phone Number</Text>
            <View style={{ 
              borderWidth: 1, 
              borderColor: '#E2E8F0', 
              borderRadius: 12, 
              padding: 14, 
              marginBottom: 20,
              backgroundColor: '#F8FAFC'
            }}>
              <Text style={{ fontSize: 16, color: '#0F172A' }}>
                {profile?.phoneNumber || 'No phone number set'}
              </Text>
            </View>

            {/* New Phone Number - now always starts empty */}
            <Text style={{ fontSize: 15, color: '#64748B', marginBottom: 6 }}>New Phone Number</Text>
            <TextInput
              style={{ 
                borderWidth: 1, 
                borderColor: '#1C8EDA', 
                borderRadius: 12, 
                padding: 14, 
                marginBottom: 24,
                fontSize: 16 
              }}
              placeholder="+234 801 234 5678"
              keyboardType="phone-pad"
              value={newPhoneNumber}
              onChangeText={setNewPhoneNumber}
            />

            <TouchableOpacity 
              onPress={handleChangePhone}
              disabled={phoneLoading}
              style={{ backgroundColor: '#1C8EDA', padding: 16, borderRadius: 999, alignItems: 'center' }}
            >
              <Text style={{ color: '#fff', fontWeight: '600', fontSize: 17 }}>
                {phoneLoading ? 'Updating...' : 'Update Phone Number'}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity 
              onPress={() => setShowPhoneModal(false)}
              style={{ marginTop: 16, alignItems: 'center' }}
            >
              <Text style={{ color: '#64748B' }}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </KeyboardAvoidingView>
      </Modal>
    </SafeAreaView>
  );
}