import React, { useEffect } from 'react';
import { ScrollView, View, Text, TouchableOpacity, TextInput, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import { homeStyles } from '../styles/home.styles';
import { useAuth } from '../context/AuthContext';

export default function HomeScreen() {
  const router = useRouter();
  const { user, logout, isSignedIn, isLoading } = useAuth();

  useEffect(() => {
    if (!isLoading && !isSignedIn) {
      router.replace('/login');
    }
  }, [isSignedIn, isLoading, router]);

  if (isLoading || !isSignedIn) {
    return null;
  }

  const goToPromotions = () => {
    router.push('/merchants/promotions'); 
  };

  return (
    <ScrollView style={homeStyles.container} showsVerticalScrollIndicator={false}>
      {/* Header */}
      <View style={homeStyles.header}>
        <View>
          <Text style={homeStyles.greeting}>Good morning,</Text>
          <Text style={homeStyles.title}>Chief 👋</Text>
        </View>

        <View style={{ flexDirection: 'row', gap: 12 }}>
          {user?.role === 'MERCHANT' && (
            <TouchableOpacity 
              style={[homeStyles.logoutButton, { backgroundColor: '#1C8EDA' }]} 
              onPress={goToPromotions}
            >
              <Text style={homeStyles.logoutText}>Run Promo</Text>
            </TouchableOpacity>
          )}
          
          <TouchableOpacity style={homeStyles.logoutButton} onPress={logout}>
            <Text style={homeStyles.logoutText}>Logout</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Search Bar */}
      <View style={homeStyles.searchContainer}>
        <Feather name="search" size={22} color="#64748B" />
        <TextInput
          style={homeStyles.searchInput}
          placeholder="Search deals, merchants..."
          placeholderTextColor="#94A3B8"
        />
      </View>

      {/* Featured / Hero Deal */}
      <View style={homeStyles.dealCard}>
        <Text style={{ color: 'white', fontSize: 15, fontWeight: '600', marginBottom: 8 }}>
          TODAY'S BEST DEAL
        </Text>
        <Text style={{ color: 'white', fontSize: 24, fontWeight: '700', marginBottom: 12 }}>
          ₦2,000 OFF
        </Text>
        <Text style={{ color: '#E0F2FE', fontSize: 16 }}>
          on orders above ₦8,000 from selected merchants
        </Text>
        <TouchableOpacity style={{ marginTop: 20, backgroundColor: 'white', alignSelf: 'flex-start', paddingHorizontal: 20, paddingVertical: 10, borderRadius: 999 }}>
          <Text style={{ color: '#1C8EDA', fontWeight: '600' }}>Claim Deal</Text>
        </TouchableOpacity>
      </View>

      {/* Nearby Promotions */}
      <Text style={homeStyles.sectionTitle}>Nearby Promotions</Text>
      
      {[1, 2, 3].map((item) => (
        <View key={item} style={homeStyles.card}>
          <Text style={{ fontSize: 18, fontWeight: '600', color: '#0F172A' }}>
            25% Off Chicken & Chips
          </Text>
          <Text style={{ color: '#64748B', marginTop: 4 }}>Mama's Kitchen • 1.2km away</Text>
          <Text style={{ color: '#1C8EDA', marginTop: 12, fontWeight: '600' }}>
            Expires in 4 hours
          </Text>
        </View>
      ))}

      {/* Categories / More Sections */}
      <Text style={[homeStyles.sectionTitle, { marginTop: 20 }]}>Explore Categories</Text>
      
      <View style={{ flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 20, gap: 12, marginBottom: 40 }}>
        {['Food', 'Fashion', 'Groceries', 'Health', 'Electronics'].map((cat) => (
          <TouchableOpacity key={cat} style={{
            backgroundColor: '#FFFFFF',
            paddingHorizontal: 20,
            paddingVertical: 14,
            borderRadius: 999,
            borderWidth: 1,
            borderColor: '#E2E8F0'
          }}>
            <Text style={{ color: '#0F172A', fontWeight: '500' }}>{cat}</Text>
          </TouchableOpacity>
        ))}
      </View>
    </ScrollView>
  );
}