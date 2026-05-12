import React, { useState, useEffect, useCallback } from 'react';
import {
  ScrollView,
  View,
  Text,
  ActivityIndicator,
  Alert,
  RefreshControl,
  TouchableOpacity
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import QRCode from 'react-native-qrcode-svg';
import { useAuth } from '../../context/AuthContext';
import { useFavourites } from '../../context/FavouritesContext';
import { apiService } from '../../services/api';
import { redemptionStyles } from '../../styles/redemption.styles';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function MyRedemptionsScreen() {
  const router = useRouter();
  const { isSignedIn, isLoading: authLoading } = useAuth();
  const { favourites, loading: favouritesLoading, refreshFavourites } = useFavourites();

  const [redemptions, setRedemptions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadMyRedemptions = async () => {
    if (!isSignedIn) return;
    try {
      const data = await apiService.getMyRedemptions();
      setRedemptions(data);
      setError(null);
    } catch (err) {
      setError('Could not load your vouchers');
      Alert.alert('Error', 'Could not load your vouchers');
    } finally {
      setLoading(false);
    }
  };

  useFocusEffect(
    useCallback(() => {
      if (isSignedIn) {
        loadMyRedemptions();
        refreshFavourites();
      }
    }, [isSignedIn])
  );

  const onRefresh = async () => {
    setRefreshing(true);
    await Promise.all([loadMyRedemptions(), refreshFavourites()]);
    setRefreshing(false);
  };

  if (authLoading || loading) {
    return (
      <SafeAreaView style={redemptionStyles.container} edges={['top']}>
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
          <ActivityIndicator size="large" color="#1C8EDA" />
        </View>
      </SafeAreaView>
    );
  }

  const activeVouchers = redemptions.filter((r) => !r.isRedeemed);
  const redeemedVouchers = redemptions.filter((r) => r.isRedeemed);

  return (
    <SafeAreaView style={redemptionStyles.container} edges={['top']}>
      <ScrollView
        style={{ flex: 1 }}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
      >
        <View style={{ padding: 20 }}>
          <Text style={redemptionStyles.header}>My Activity</Text>
          <Text style={redemptionStyles.subHeader}>
            Your vouchers, favourites & history
          </Text>

          {/* Favourites Section */}
          <Text style={redemptionStyles.sectionTitle}>Favourites</Text>
          {favourites.length === 0 ? (
            <Text style={{ color: '#64748B', textAlign: 'center', padding: 40 }}>
              No favourited promotions yet{'\n'}Tap the heart on any promotion
            </Text>
          ) : (
            favourites.map((fav) => {
              const promo = fav.promotion;
              if (!promo) return null;
              return (
                <TouchableOpacity 
                  key={fav.promotionId} 
                  style={redemptionStyles.card}
                  onPress={() => router.push({ pathname: '/promotions/[id]', params: { id: promo.id } })}
                >
                  <Text style={{ fontSize: 18, fontWeight: '600', marginBottom: 4 }}>
                    {promo.title}
                  </Text>
                  <Text style={{ color: '#64748B' }}>
                    {promo.merchant?.businessName}
                  </Text>
                </TouchableOpacity>
              );
            })
          )}

          {/* Active Vouchers */}
          <Text style={redemptionStyles.sectionTitle}>Active Vouchers</Text>
          {activeVouchers.length === 0 ? (
            <Text style={{ color: '#64748B', textAlign: 'center', padding: 40 }}>
              No active vouchers yet{'\n'}Generate one from a promotion!
            </Text>
          ) : (
            activeVouchers.map((redemption) => (
              <View key={redemption.id} style={redemptionStyles.card}>
                <Text style={{ fontSize: 18, fontWeight: '600', marginBottom: 4 }}>
                  {redemption.promotion?.title}
                </Text>
                <Text style={{ color: '#64748B', marginBottom: 8 }}>
                  {redemption.promotion?.merchant?.businessName}
                </Text>

                <View style={{ marginBottom: 16 }}>
                  {redemption.promotion?.merchant?.phoneNumber && (
                    <Text style={{ color: '#10B981', fontWeight: '600', marginBottom: 4 }}>
                      📞 {redemption.promotion.merchant.phoneNumber}
                    </Text>
                  )}
                  {redemption.promotion?.merchant?.address && (
                    <Text style={{ color: '#64748B' }}>
                      📍 {redemption.promotion.merchant.address}
                    </Text>
                  )}
                </View>

                <View style={redemptionStyles.qrContainer}>
                  <QRCode value={redemption.qrCode} size={240} color="#1C8EDA" />
                </View>

                <Text style={redemptionStyles.instructionText}>
                  Show this QR to merchant
                </Text>
                <Text style={redemptionStyles.expiryText}>
                  Expires: {new Date(redemption.promotion?.expiry).toLocaleDateString('en-NG')}
                </Text>

                <Text style={{ marginTop: 12, color: '#10B981', fontSize: 13 }}>
                  Quantity: {redemption.quantity || 1}
                </Text>
              </View>
            ))
          )}

          {/* Past Redemptions */}
          {redeemedVouchers.length > 0 && (
            <>
              <Text style={redemptionStyles.sectionTitle}>Past Redemptions</Text>
              {redeemedVouchers.map((redemption) => (
                <View key={redemption.id} style={[redemptionStyles.historyCard, { opacity: 0.85 }]}>
                  <Text style={{ fontSize: 16, fontWeight: '600' }}>
                    {redemption.promotion?.title}
                  </Text>
                  <Text style={{ color: '#10B981', marginTop: 4 }}>Redeemed</Text>
                  <Text style={{ color: '#64748B', fontSize: 13, marginTop: 4 }}>
                    Scanned on {new Date(redemption.redeemedAt).toLocaleDateString('en-NG')}
                  </Text>
                </View>
              ))}
            </>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}