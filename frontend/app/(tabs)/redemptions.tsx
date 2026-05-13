import React, { useState, useEffect, useCallback } from 'react';
import {
  ScrollView,
  View,
  Text,
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

// New UI Components
import { LoadingSkeleton } from '../../components/ui/LoadingSkeleton';
import { ErrorState } from '../../components/ui/ErrorState';
import { EmptyState } from '../../components/ui/EmptyState';

export default function MyRedemptionsScreen() {
  const router = useRouter();
  const { isSignedIn, isLoading: authLoading } = useAuth();
  const { favourites, loading: favouritesLoading, refreshFavourites } = useFavourites();

  const [redemptions, setRedemptions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<'favourites' | 'active' | 'past'>('favourites');

  const loadMyRedemptions = async () => {
    if (!isSignedIn) return;
    setLoading(true);
    setError(null);
    try {
      const data = await apiService.getMyRedemptions();
      setRedemptions(data);
    } catch (err: any) {
      setError('Could not load your vouchers. Pull down to retry.');
    } finally {
      setLoading(false);
    }
  };

  const retryLoad = () => {
    setError(null);
    loadMyRedemptions();
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
        <LoadingSkeleton />
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

          {/* Internal Tabs */}
          <View style={{
            flexDirection: 'row',
            backgroundColor: '#F1F5F9',
            borderRadius: 999,
            padding: 4,
            marginBottom: 24
          }}>
            {(['favourites', 'active', 'past'] as const).map((tab) => (
              <TouchableOpacity
                key={tab}
                onPress={() => setActiveTab(tab)}
                style={{
                  flex: 1,
                  paddingVertical: 10,
                  borderRadius: 999,
                  backgroundColor: activeTab === tab ? '#1C8EDA' : 'transparent',
                  alignItems: 'center',
                }}
              >
                <Text style={{
                  color: activeTab === tab ? '#fff' : '#64748B',
                  fontWeight: '600',
                  fontSize: 15
                }}>
                  {tab === 'favourites' ? 'Favourites' : tab === 'active' ? 'Vouchers' : 'Redemptions'}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* FAVOURITES TAB */}
          {activeTab === 'favourites' && (
            <>
              {favouritesLoading ? (
                <LoadingSkeleton />
              ) : favourites.length === 0 ? (
                <EmptyState 
                  icon="heart" 
                  title="No favourites yet" 
                  subtitle="Tap the heart on any promotion to save it here" 
                />
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
            </>
          )}

          {/* ACTIVE VOUCHERS TAB */}
          {activeTab === 'active' && (
            <>
              {activeVouchers.length === 0 ? (
                <EmptyState 
                  icon="award" 
                  title="No active vouchers" 
                  subtitle="Generate a QR code from a promotion!" 
                />
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
            </>
          )}

          {/* PAST REDEMPTIONS TAB */}
          {activeTab === 'past' && (
            <>
              {redeemedVouchers.length === 0 ? (
                <EmptyState 
                  icon="clock" 
                  title="No past redemptions yet" 
                  subtitle="Your redeemed vouchers will appear here" 
                />
              ) : (
                redeemedVouchers.map((redemption) => (
                  <View key={redemption.id} style={[redemptionStyles.historyCard, { opacity: 0.85 }]}>
                    <Text style={{ fontSize: 16, fontWeight: '600' }}>
                      {redemption.promotion?.title}
                    </Text>
                    <Text style={{ color: '#10B981', marginTop: 4 }}>Redeemed</Text>
                    <Text style={{ color: '#64748B', fontSize: 13, marginTop: 4 }}>
                      Scanned on {new Date(redemption.redeemedAt).toLocaleDateString('en-NG')}
                    </Text>
                  </View>
                ))
              )}
            </>
          )}

          {error && <ErrorState message={error} onRetry={retryLoad} />}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}