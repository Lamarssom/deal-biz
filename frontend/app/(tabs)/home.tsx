import React, { useState, useEffect, useCallback } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
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
import { useNetwork } from '../../context/NetworkContext';

// UI Components
import { LoadingSkeleton } from '../../components/ui/LoadingSkeleton';
import { ErrorState } from '../../components/ui/ErrorState';
import { EmptyState } from '../../components/ui/EmptyState';

export default function HomeScreen() {
  const router = useRouter();
  const { user, isSignedIn, isLoading: authLoading } = useAuth();
  const { isFavourite, toggleFavourite, refreshFavourites } = useFavourites();
  const { isConnected } = useNetwork();

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

  const openScan = () => router.push('/scan');

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
    } catch (error: any) {
      setError("Couldn't load promotions. Check your connection.");
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
        {/* Modern Header with perfectly aligned buttons */}
        <View style={homeStyles.header}>
          <View>
            <Text style={homeStyles.greeting}>{getGreeting()},</Text>
            <Text style={homeStyles.title}>Chief 👋</Text>
          </View>

          <View style={{ flexDirection: 'row', gap: 8 }}>
            {/* Run Promo */}
            {user?.role === 'MERCHANT' && (
              <TouchableOpacity 
                style={{
                  backgroundColor: '#1C8EDA',
                  height: 48,
                  paddingHorizontal: 20,
                  borderRadius: 999,
                  flexDirection: 'row',
                  alignItems: 'center',
                  justifyContent: 'center',
                }} 
                onPress={goToPromotions}
              >
                <Text style={{ color: '#FFFFFF', fontWeight: '600', fontSize: 15 }}>
                  Run Promo
                </Text>
              </TouchableOpacity>
            )}

            {/* Modern Scan QR - lighter black, perfect alignment */}
            {user?.role === 'MERCHANT' && (
              <TouchableOpacity 
                style={{
                  backgroundColor: '#1F2937',
                  height: 48,
                  paddingHorizontal: 20,
                  borderRadius: 999,
                  flexDirection: 'row',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: 8,
                }} 
                onPress={openScan}
              >
                <Feather name="camera" size={20} color="#FFFFFF" />
                <Text style={{ color: '#FFFFFF', fontWeight: '600', fontSize: 15 }}>Scan QR</Text>
              </TouchableOpacity>
            )}
          </View>
        </View>

        {/* Nearby Promotions Header */}
        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, marginTop: 20 }}>
          <Text style={homeStyles.sectionTitle}>Nearby Promotions</Text>
          {locationLoading && <ActivityIndicator color="#1C8EDA" />}
        </View>

        {/* Loading / Error / Empty / List */}
        {loading && <LoadingSkeleton />}
        {error && !loading && <ErrorState message={error} onRetry={() => getUserLocation()} />}
        {!loading && !error && filteredPromotions.length === 0 && (
          <EmptyState 
            icon="search" 
            title="No promotions found" 
            subtitle="Try changing your search or location" 
          />
        )}

        {!loading && !error && filteredPromotions.length > 0 && filteredPromotions.map((promo: any) => {
          const favourited = isFavourite(promo.id);
          return (
            <TouchableOpacity 
              key={promo.id} 
              style={homeStyles.card}
              onPress={() => handlePromotionPress(promo.id)}
              activeOpacity={0.8}
            >
              {promo.photoUrl && !promo.photoUrl.startsWith('file://') ? (
                <Image source={{ uri: promo.photoUrl }} style={{ width: '100%', height: 160, borderRadius: 16, marginBottom: 12 }} resizeMode="cover" />
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
      </ScrollView>
    </SafeAreaView>
  );
}