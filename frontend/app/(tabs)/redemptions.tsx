import React, { useState, useEffect } from 'react';
import {
  ScrollView,
  View,
  Text,
  ActivityIndicator,
  Alert,
  RefreshControl,
} from 'react-native';
import { useRouter } from 'expo-router';
import QRCode from 'react-native-qrcode-svg';
import { useAuth } from '../../context/AuthContext';
import { apiService } from '../../services/api';
import { redemptionStyles } from '../../styles/redemption.styles';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function MyRedemptionsScreen() {
  const router = useRouter();
  const { isSignedIn, isLoading: authLoading } = useAuth();

  const [redemptions, setRedemptions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const loadMyRedemptions = async () => {
    if (!isSignedIn) return;
    try {
      const data = await apiService.getMyRedemptions();
      setRedemptions(data);
    } catch (error) {
      console.error('Failed to load vouchers:', error);
      Alert.alert('Error', 'Could not load your vouchers');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadMyRedemptions();
  }, [isSignedIn]);

  const onRefresh = async () => {
    setRefreshing(true);
    await loadMyRedemptions();
    setRefreshing(false);
  };

  if (authLoading || loading) {
    return (
      <View style={redemptionStyles.container}>
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
          <ActivityIndicator size="large" color="#1C8EDA" />
        </View>
      </View>
    );
  }

  const activeVouchers = redemptions.filter((r) => !r.isRedeemed);
  const historyVouchers = redemptions.filter((r) => r.isRedeemed);

  return (
    <SafeAreaView style={redemptionStyles.container} edges={['top']}>
      <ScrollView
        style={redemptionStyles.container}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} />}
      >
        <View style={{ padding: 20 }}>
          <Text style={redemptionStyles.header}>My Vouchers</Text>
          <Text style={redemptionStyles.subHeader}>
            Show these QR codes to the merchant for redemption
          </Text>

          {/* ACTIVE VOUCHERS */}
          <Text style={redemptionStyles.sectionTitle}>Active Vouchers</Text>
          {activeVouchers.length === 0 ? (
            <Text style={{ color: '#64748B', textAlign: 'center', padding: 40 }}>
              No active vouchers yet{'\n'}Generate one from a promotion!
            </Text>
          ) : (
            activeVouchers.map((redemption) => (
              <View key={redemption.id} style={redemptionStyles.card}>
                <Text style={{ fontSize: 18, fontWeight: '600' }}>
                  {redemption.promotion?.title}
                </Text>
                <Text style={{ color: '#64748B', marginBottom: 16 }}>
                  {redemption.promotion?.merchant?.businessName}
                </Text>

                <View style={redemptionStyles.qrContainer}>
                  <QRCode value={redemption.qrCode} size={240} color="#1C8EDA" />
                </View>

                <Text style={redemptionStyles.instructionText}>
                  Show this QR to merchant
                </Text>
                <Text style={redemptionStyles.expiryText}>
                  Expires: {new Date(redemption.promotion?.expiry).toLocaleDateString('en-NG')}
                </Text>
              </View>
            ))
          )}

          {/* HISTORY */}
          {historyVouchers.length > 0 && (
            <>
              <Text style={redemptionStyles.sectionTitle}>Redeemed Vouchers</Text>
              {historyVouchers.map((redemption) => (
                <View key={redemption.id} style={redemptionStyles.historyCard}>
                  <Text style={{ fontSize: 16, fontWeight: '600' }}>
                    {redemption.promotion?.title}
                  </Text>
                  <Text style={{ color: '#10B981' }}>✅ Redeemed</Text>
                </View>
              ))}
            </>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}