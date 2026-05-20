import React, { useState, useEffect, useCallback } from 'react';
import {
  ScrollView,
  View,
  Text,
  TouchableOpacity,
  ActivityIndicator,
  Image,
  RefreshControl,
  Platform,
  Alert,
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

  // Live location - no hardcoded values
  const [currentLocation, setCurrentLocation] = useState<{ lat: number; lng: number } | null>(null);

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  };

  const getPercentageOff = (promo: any) => {
    if (!promo.originalPrice || !promo.price) return 0;
    return Math.round(((promo.originalPrice - promo.price) / promo.originalPrice) * 100);
  };

  const isActivePromotion = (promo: any) => {
    const expired = new Date(promo.expiry) < new Date();
    const exhausted = promo.quantityLimit && (promo.redeemedCount || 0) >= promo.quantityLimit;
    return !expired && !exhausted;
  };

  const sortByNewest = (promos: any[]) => {
    return [...promos].sort((a, b) => {
      const timeA = a.createdAt ? new Date(a.createdAt).getTime() : 0;
      const timeB = b.createdAt ? new Date(b.createdAt).getTime() : 0;
      return timeB - timeA;
    });
  };

  const bestDeals = React.useMemo(() => {
    return [...promotions]
      .filter(isActivePromotion)
      .sort((a, b) => {
        const timeA = a.createdAt ? new Date(a.createdAt).getTime() : 0;
        const timeB = b.createdAt ? new Date(b.createdAt).getTime() : 0;
        if (timeB !== timeA) return timeB - timeA;
        return getPercentageOff(b) - getPercentageOff(a);
      })
      .slice(0, 5);
  }, [promotions]);

  const estimateDriveTime = (distanceKm: number) => {
    const minutes = Math.round(distanceKm * 3.5);
    if (minutes < 10) return '< 10 min';
    if (minutes > 45) return '> 45 min';
    return `${Math.max(10, Math.round(minutes / 5) * 5)}-${Math.round(minutes / 5) * 5 + 5} min`;
  };

  // REAL-TIME LOCATION – web + mobile (no hardcoded coordinates)
  const getUserLocation = async () => {
    setLocationLoading(true);
    setError(null);

    try {
      let latitude: number;
      let longitude: number;

      if (Platform.OS === 'web') {
        if (!navigator.geolocation) {
          throw new Error('Geolocation not supported');
        }

        const position = await new Promise<GeolocationPosition>((resolve, reject) => {
          navigator.geolocation.getCurrentPosition(resolve, reject, {
            enableHighAccuracy: false,   // faster on web
            timeout: 15000,              // 15s timeout
            maximumAge: 30000,           // accept 30s old location
          });
        });

        latitude = position.coords.latitude;
        longitude = position.coords.longitude;
      } else {
        // Mobile
        const { status } = await Location.requestForegroundPermissionsAsync();
        if (status !== 'granted') {
          Alert.alert('Location Permission', 'Location is required for nearby promotions.');
          setError('Location permission denied.');
          return;
        }
        const loc = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Balanced });
        latitude = loc.coords.latitude;
        longitude = loc.coords.longitude;
      }

      setCurrentLocation({ lat: latitude, lng: longitude });
      await loadPromotions(latitude, longitude);
    } catch (err: any) {
      console.error('Location error:', err);
      if (err.code === 3) {
        setError('Location request timed out. Please try again.');
      } else {
        setError('Could not get your location. Please try again.');
      }
    } finally {
      setLocationLoading(false);
      setLoading(false);
    }
  };

  const loadPromotions = async (lat: number, lng: number) => {
    try {
      const data = await apiService.getNearbyPromotions(lat, lng, 30);
      setPromotions(data);
      setFilteredPromotions(sortByNewest(data));
      setError(null);
    } catch (error: any) {
      setError("Couldn't load promotions. Check your connection.");
    }
  };

  useFocusEffect(
    useCallback(() => {
      if (isSignedIn && user) {
        getUserLocation();
        refreshFavourites();
      }
    }, [isSignedIn, user, refreshFavourites])
  );

  useEffect(() => {
    if (!searchQuery.trim()) {
      setFilteredPromotions(sortByNewest(promotions));
      return;
    }
    const query = searchQuery.toLowerCase().trim();
    const filtered = promotions.filter((promo: any) =>
      promo.title?.toLowerCase().includes(query) ||
      promo.merchant?.businessName?.toLowerCase().includes(query) ||
      promo.description?.toLowerCase().includes(query)
    );
    setFilteredPromotions(sortByNewest(filtered));
  }, [searchQuery, promotions]);

  const onRefresh = async () => {
    setRefreshing(true);
    if (currentLocation) {
      await loadPromotions(currentLocation.lat, currentLocation.lng);
    } else {
      await getUserLocation();
    }
    setRefreshing(false);
  };

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
        {/* Header */}
        <View style={homeStyles.header}>
          <View>
            <Text style={homeStyles.greeting}>{getGreeting()},</Text>
            <Text style={homeStyles.title}>Chief 👋</Text>
          </View>

          <View style={{ flexDirection: 'row', gap: 8 }}>
            {user?.role === 'MERCHANT' && (
              <>
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
                  onPress={() => router.push('/merchants/promotions')}
                >
                  <Text style={{ color: '#FFFFFF', fontWeight: '600', fontSize: 15 }}>Run Promo</Text>
                </TouchableOpacity>

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
                  onPress={() => router.push('/scan')}
                >
                  <Feather name="camera" size={20} color="#FFFFFF" />
                  <Text style={{ color: '#FFFFFF', fontWeight: '600', fontSize: 15 }}>Scan QR</Text>
                </TouchableOpacity>
              </>
            )}
          </View>
        </View>

        {/* Best Deals */}
        {bestDeals.length > 0 && (
          <>
            <View style={{ paddingHorizontal: 20, marginTop: 20 }}>
              <Text style={[homeStyles.sectionTitle, { color: '#000000' }]}>Best Deals</Text>
            </View>

            <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ paddingLeft: 20 }}>
              {bestDeals.map((promo: any) => {
                const perc = getPercentageOff(promo);
                return (
                  <TouchableOpacity key={promo.id} style={homeStyles.bestDealCard} onPress={() => handlePromotionPress(promo.id)}>
                    <View style={{ position: 'relative' }}>
                      {promo.photoUrl ? (
                        <Image source={{ uri: promo.photoUrl }} style={{ width: '100%', height: 140 }} resizeMode="cover" />
                      ) : (
                        <View style={{ height: 140, backgroundColor: '#E2E8F0', justifyContent: 'center', alignItems: 'center' }}>
                          <Text style={{ color: '#64748B' }}>No image</Text>
                        </View>
                      )}
                      {perc > 0 && (
                        <View style={homeStyles.percentageBadge}>
                          <Text style={homeStyles.percentageBadgeText}>{perc}% OFF</Text>
                        </View>
                      )}
                    </View>

                    <View style={{ padding: 12 }}>
                      <Text style={{ fontSize: 15, fontWeight: '600', color: '#0F172A' }}>
                        {promo.merchant?.businessName}
                      </Text>
                      <View style={{ flexDirection: 'row', marginTop: 6, gap: 8, alignItems: 'center' }}>
                        <Text style={{ color: '#1C8EDA', fontWeight: '700', fontSize: 18 }}>
                          ₦{promo.price}
                        </Text>
                        <Text style={{ color: '#64748B', fontSize: 13 }}>
                          {promo.distanceKm} km • {estimateDriveTime(promo.distanceKm)}
                        </Text>
                      </View>
                    </View>
                  </TouchableOpacity>
                );
              })}
            </ScrollView>
          </>
        )}

        {/* Nearby Promotions */}
        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, marginTop: 28 }}>
          <Text style={homeStyles.sectionTitle}>Nearby Promotions</Text>
          {locationLoading && <ActivityIndicator color="#1C8EDA" />}
        </View>

        {loading && <LoadingSkeleton />}
        {error && !loading && <ErrorState message={error} onRetry={() => getUserLocation()} />}

        {!loading && !error && filteredPromotions.filter(isActivePromotion).length === 0 && (
          <EmptyState icon="search" title="No promotions found" subtitle="Try changing your search or location" />
        )}

        {!loading && !error && filteredPromotions.filter(isActivePromotion).length > 0 &&
          filteredPromotions.filter(isActivePromotion).map((promo: any) => {
            const favourited = isFavourite(promo.id);
            const perc = getPercentageOff(promo);

            return (
              <TouchableOpacity
                key={promo.id}
                style={homeStyles.card}
                onPress={() => handlePromotionPress(promo.id)}
                activeOpacity={0.8}
              >
                <View style={{ position: 'relative' }}>
                  {promo.photoUrl ? (
                    <Image source={{ uri: promo.photoUrl }} style={{ width: '100%', height: 160, borderRadius: 16, marginBottom: 12 }} resizeMode="cover" />
                  ) : (
                    <View style={{ height: 160, backgroundColor: '#E2E8F0', borderRadius: 16, marginBottom: 12, justifyContent: 'center', alignItems: 'center' }}>
                      <Text style={{ color: '#64748B', fontWeight: '500' }}>📸 No image</Text>
                    </View>
                  )}

                  {perc > 0 && (
                    <View style={homeStyles.percentageBadge}>
                      <Text style={homeStyles.percentageBadgeText}>{perc}% OFF</Text>
                    </View>
                  )}
                </View>

                <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                  <Text style={{ fontSize: 18, fontWeight: '600', color: '#0F172A', flex: 1 }}>
                    {promo.merchant?.businessName}
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
                  {promo.distanceKm} km • {estimateDriveTime(promo.distanceKm)}
                </Text>

                <View style={{ flexDirection: 'row', marginTop: 8, gap: 8 }}>
                  <Text style={{ color: '#1C8EDA', fontWeight: '700', fontSize: 18 }}>
                    ₦{promo.price}
                  </Text>
                </View>
              </TouchableOpacity>
            );
          })}
      </ScrollView>
    </SafeAreaView>
  );
}