import React, { useState, useEffect } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  TextInput, 
  Alert,
  ActivityIndicator 
} from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import * as Location from 'expo-location';

import { homeStyles } from '../styles/home.styles';
import { useAuth } from '../context/AuthContext';
import { apiService } from '../services/api';

export default function HomeScreen() {
  const router = useRouter();
  const { user, logout, isSignedIn, isLoading } = useAuth();

  const [promotions, setPromotions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [locationLoading, setLocationLoading] = useState(false);

  // ✅ Improved auth check
  useEffect(() => {
    if (isLoading) return; // Wait until auth is fully initialized

    if (!isSignedIn) {
      router.replace('/login');
    } else {
      getUserLocation();
    }
  }, [isLoading, isSignedIn]); // Only run when loading finishes

  const getUserLocation = async () => {
    setLocationLoading(true);
    try {
      const { status } = await Location.requestForegroundPermissionsAsync();
      
      if (status !== 'granted') {
        Alert.alert("Permission Denied", "Using default Lagos location");
        await loadPromotions(6.5244, 3.3792);
        return;
      }

      const location = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.Balanced,
      });

      await loadPromotions(location.coords.latitude, location.coords.longitude);
    } catch (error) {
      console.log("Location error:", error);
      await loadPromotions(6.5244, 3.3792);
    } finally {
      setLocationLoading(false);
    }
  };

  const loadPromotions = async (lat: number, lng: number) => {
    try {
      console.log(`📍 Fetching promotions near: ${lat}, ${lng}`);
      const data = await apiService.getNearbyPromotions(lat, lng, 30);
      console.log(`✅ Received ${data.length} promotions`);
      setPromotions(data);
    } catch (error) {
      console.error('Failed to load promotions:', error);
    } finally {
      setLoading(false);
    }
  };

  const goToPromotions = () => {
    router.push('/merchants/promotions');
  };

  const handlePromotionPress = (promotionId: string) => {
    router.push({
      pathname: '/promotions/[id]',
      params: { id: promotionId },
    });
  };

  // Show loading state while auth is initializing
  if (isLoading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color="#1C8EDA" />
      </View>
    );
  }

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

      {/* Featured Deal - keep as is */}

      {/* Nearby Promotions */}
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, marginTop: 20 }}>
        <Text style={homeStyles.sectionTitle}>Nearby Promotions</Text>
        {locationLoading && <ActivityIndicator color="#1C8EDA" />}
      </View>

      {loading ? (
        <Text style={{ padding: 20, textAlign: 'center' }}>Finding best deals near you...</Text>
      ) : promotions.length === 0 ? (
        <Text style={{ padding: 20, textAlign: 'center', color: '#64748B' }}>
          No active promotions nearby right now
        </Text>
      ) : (
        promotions.map((promo: any) => (
          <TouchableOpacity 
            key={promo.id} 
            style={homeStyles.card}
            onPress={() => handlePromotionPress(promo.id)}
            activeOpacity={0.8}
          >
            <Text style={{ fontSize: 18, fontWeight: '600', color: '#0F172A' }}>
              {promo.title}
            </Text>
            
            <Text style={{ color: '#64748B', marginTop: 4 }}>
              {promo.merchant?.businessName} • {promo.distanceKm}km away
            </Text>

            <View style={{ flexDirection: 'row', marginTop: 8, gap: 8 }}>
              <Text style={{ color: '#1C8EDA', fontWeight: '700', fontSize: 18 }}>
                ₦{promo.price}
              </Text>
              <Text style={{ textDecorationLine: 'line-through', color: '#94A3B8' }}>
                ₦{promo.originalPrice}
              </Text>
            </View>

            <Text style={{ color: '#10B981', marginTop: 8, fontWeight: '600' }}>
              Expires: {new Date(promo.expiry).toLocaleDateString('en-NG')}
            </Text>
          </TouchableOpacity>
        ))
      )}

      {/* Categories Section */}
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