import React, { useState } from 'react';
import { ScrollView, View, Text, TouchableOpacity, Modal, TextInput, Switch, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import { useAuth } from '../../context/AuthContext';
import { SafeAreaView } from 'react-native-safe-area-context';
import Toast from 'react-native-toast-message';

export default function ProfileScreen() {
  const { user, logout } = useAuth();
  const router = useRouter();

  const [showPasswordModal, setShowPasswordModal] = useState(false);
  const [showPhoneModal, setShowPhoneModal] = useState(false);
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);

  const handleLogout = () => {
    Alert.alert('Logout', 'Are you sure?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Logout', style: 'destructive', onPress: async () => {
        await logout();
        router.replace('/login');
      }},
    ]);
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#F8FAFC' }}>
      <ScrollView style={{ flex: 1 }}>
        <View style={{ padding: 24, backgroundColor: '#1C8EDA', alignItems: 'center' }}>
          <Feather name="user" size={80} color="#fff" />
          <Text style={{ color: '#fff', fontSize: 22, fontWeight: '700', marginTop: 12 }}>
            {user?.email || 'Welcome'}
          </Text>
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
            onPress={() => setShowPhoneModal(true)}
          >
            <Feather name="phone" size={24} color="#1C8EDA" />
            <Text style={{ flex: 1, marginLeft: 16, fontSize: 17 }}>Change Phone Number</Text>
            <Feather name="chevron-right" size={24} color="#64748B" />
          </TouchableOpacity>

          {/* Notifications */}
          <View style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 16, borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}>
            <Feather name="bell" size={24} color="#1C8EDA" />
            <Text style={{ flex: 1, marginLeft: 16, fontSize: 17 }}>Notifications</Text>
            <Switch value={notificationsEnabled} onValueChange={setNotificationsEnabled} />
          </View>

          {/* Logout */}
          <TouchableOpacity 
            onPress={handleLogout}
            style={{ marginTop: 40, backgroundColor: '#EF4444', padding: 16, borderRadius: 999, alignItems: 'center' }}
          >
            <Text style={{ color: '#fff', fontSize: 17, fontWeight: '600' }}>Logout</Text>
          </TouchableOpacity>
        </View>

        {/* Modals will be added in next step if you want full implementation */}
      </ScrollView>
    </SafeAreaView>
  );
}