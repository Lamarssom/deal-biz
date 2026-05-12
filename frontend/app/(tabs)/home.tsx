import React, { useState, useEffect, useCallback } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  TextInput, 
  Alert,
  ActivityIndicator,
  Image,
  RefreshControl,
  Platform
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import * as Location from 'expo-location';

import { homeStyles } from '../../styles/home.styles';
import { useAuth } from '../../context/AuthContext';
import { useFavourites } from '../../context/FavouritesContext';
import { apiService } from '../../services/api';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function HomeScreen() {
  const router = useRouter();
  const { user, logout, isSignedIn, isLoading: authLoading } = useAuth();
  const { isFavourite, toggleFavourite, refreshFavourites } = useFavourites();

  const [promotions, setPromotions] = useState<any[]>([]);
  const [filteredPromotions, setFilteredPromotions] = useState<any[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [locationLoading, setLocationLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [lastLat, setLastLat] = useState<number>(6.5244);
  const [lastLng, setLastLng] = useState<number>(3.3792);

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  };

  useFocusEffect(
    useCallback(() => {
      if (isSignedIn && user) {
        getUserLocation();
        refreshFavourites();
      }
    }, [isSignedIn, user, refreshFavourites])
  );

  const getUserLocation = async () => {
    if (Platform.OS === 'web') {
      await loadPromotions(lastLat, lastLng);
      return;
    }

    setLocationLoading(true);
    setError(null);

    try {
      const { status } = await Location.requestForegroundPermissionsAsync();
      if (status !== 'granted') {
        await loadPromotions(lastLat, lastLng);
        return;
      }

      const location = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Balanced });
      const { latitude, longitude } = location.coords;
      setLastLat(latitude);
      setLastLng(longitude);
      await loadPromotions(latitude, longitude);
    } catch (err) {
      await loadPromotions(lastLat, lastLng);
    } finally {
      setLocationLoading(false);
    }
  };

  const loadPromotions = async (lat: number, lng: number) => {
    try {
      const data = await apiService.getNearbyPromotions(lat, lng, 30);
      setPromotions(data);
      setFilteredPromotions(data);
      setError(null);
    } catch (error) {
      setError("Couldn't load promotions. Pull down to retry.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (!searchQuery.trim()) {
      setFilteredPromotions(promotions);
      return;
    }

    const query = searchQuery.toLowerCase().trim();
    const filtered = promotions.filter((promo: any) =>
      promo.title?.toLowerCase().includes(query) ||
      promo.merchant?.businessName?.toLowerCase().includes(query) ||
      promo.description?.toLowerCase().includes(query)
    );
    setFilteredPromotions(filtered);
  }, [searchQuery, promotions]);

  const onRefresh = async () => {
    setRefreshing(true);
    await loadPromotions(lastLat, lastLng);
    setRefreshing(false);
  };

  const goToPromotions = () => router.push('/merchants/promotions');

  const handlePromotionPress = (promotionId: string) => {
    router.push({ pathname: '/promotions/[id]', params: { id: promotionId } });
  };

  const handleLogout = async () => {
    await logout();
    router.replace('/login');
  };

  if (authLoading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color="#1C8EDA" />
      </View>
    );
  }

  return (
    <SafeAreaView style={homeStyles.container} edges={['top']}>
      <ScrollView 
        style={homeStyles.container} 
        showsVerticalScrollIndicator={false}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
      >
        {/* Header */}
        <View style={homeStyles.header}>
          <View>
            <Text style={homeStyles.greeting}>{getGreeting()},</Text>
            <Text style={homeStyles.title}>Chief 👋</Text>
          </View>

          <View style={homeStyles.headerButtons}>
            {user?.role === 'MERCHANT' && (
              <TouchableOpacity 
                style={[homeStyles.logoutButton, { backgroundColor: '#1C8EDA' }]} 
                onPress={goToPromotions}
              >
                <Text style={[homeStyles.logoutText, { color: '#FFFFFF' }]}>Run Promo</Text>
              </TouchableOpacity>
            )}

            <TouchableOpacity 
              style={[homeStyles.logoutButton, { backgroundColor: '#F87171' }]} 
              onPress={handleLogout}
            >
              <Text style={[homeStyles.logoutText, { color: '#FFFFFF' }]}>Logout</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Search Bar */}
        <View style={homeStyles.searchContainer}>
          <Feather name="search" size={22} color="#64748B" />
          <TextInput
            style={homeStyles.searchInput}
            placeholder="Search deals or merchants..."
            placeholderTextColor="#94A3B8"
            value={searchQuery}
            onChangeText={setSearchQuery}
            clearButtonMode="while-editing"
          />
        </View>

        {/* Nearby Promotions */}
        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, marginTop: 20 }}>
          <Text style={homeStyles.sectionTitle}>Nearby Promotions</Text>
          {locationLoading && <ActivityIndicator color="#1C8EDA" />}
        </View>

        {loading && (
          <View style={{ padding: 40, alignItems: 'center' }}>
            <ActivityIndicator size="large" color="#1C8EDA" />
            <Text style={{ marginTop: 12, color: '#64748B' }}>Finding the best deals near you...</Text>
          </View>
        )}

        {!loading && filteredPromotions.length === 0 && (
          <View style={{ padding: 40, alignItems: 'center' }}>
            <Text style={{ fontSize: 18, fontWeight: '600', color: '#0F172A' }}>No matching promotions</Text>
          </View>
        )}

        {/* Promotions List */}
        {filteredPromotions.map((promo: any) => {
          const favourited = isFavourite(promo.id);
          return (
            <TouchableOpacity 
              key={promo.id} 
              style={homeStyles.card}
              onPress={() => handlePromotionPress(promo.id)}
              activeOpacity={0.8}
            >
              {/* Image */}
              {promo.photoUrl && !promo.photoUrl.startsWith('file://') ? (
                <Image 
                  source={{ uri: promo.photoUrl }} 
                  style={{ width: '100%', height: 160, borderRadius: 16, marginBottom: 12 }}
                  resizeMode="cover"
                />
              ) : (
                <View style={{ height: 160, backgroundColor: '#E2E8F0', borderRadius: 16, marginBottom: 12, justifyContent: 'center', alignItems: 'center' }}>
                  <Text style={{ color: '#64748B', fontWeight: '500' }}>📸 No image</Text>
                </View>
              )}

              <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                <Text style={{ fontSize: 18, fontWeight: '600', color: '#0F172A', flex: 1 }}>
                  {promo.title}
                </Text>

                <TouchableOpacity 
                  onPress={(e) => { 
                    e.stopPropagation(); 
                    toggleFavourite(promo.id); 
                  }}
                >
                  <Text style={{ fontSize: 26 }}>
                    {favourited ? '❤️' : '♡'}
                  </Text>
                </TouchableOpacity>
              </View>

              <Text style={{ color: '#64748B', marginTop: 4 }}>
                {promo.merchant?.businessName} • {promo.distanceKm} km away
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
          );
        })}

        {/* Categories */}
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
    </SafeAreaView>
  );
}

function refreshFavourites() {
  throw new Error('Function not implemented.');
}
