import React, { useState, useEffect, useCallback } from 'react';
import * as Location from 'expo-location';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  ActivityIndicator, 
  Modal,
  Image,
  Platform,
  TextInput
} from 'react-native';
import { useLocalSearchParams, useRouter, useFocusEffect } from 'expo-router';
import { useAuth } from '../../context/AuthContext';
import { apiService } from '../../services/api';
import { promotionStyles } from '../../styles/promotion.styles';
import Toast from 'react-native-toast-message';

export default function PromotionDetail() {
  const router = useRouter();
  const { id } = useLocalSearchParams<{ id: string }>();
  const { user } = useAuth();

  const [promotion, setPromotion] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [qrGenerated, setQrGenerated] = useState(false);

  const [showQuantityModal, setShowQuantityModal] = useState(false);
  const [selectedQuantity, setSelectedQuantity] = useState<number>(1);

  const [userLat, setUserLat] = useState<number>(6.5244);
  const [userLng, setUserLng] = useState<number>(3.3792);

  const estimateDriveTime = (distanceKm: number) => {
    const minutes = Math.round(distanceKm * 3.5);
    if (minutes < 10) return '< 10 min';
    if (minutes > 45) return '> 45 min';
    return `${Math.max(10, Math.round(minutes / 5) * 5)}-${Math.round(minutes / 5) * 5 + 5} min`;
  };

  const isExpiredOrExhausted = (promo: any) => {
    if (!promo) return false;
    const dateExpired = new Date(promo.expiry) < new Date();
    const quantityExhausted = promo.quantityLimit && (promo.redeemedCount || 0) >= promo.quantityLimit;
    return dateExpired || quantityExhausted;
  };

  const getButtonText = (promo: any) => {
    if (!promo) return 'Generate QR Code';
    if (promo.quantityLimit && (promo.redeemedCount || 0) >= promo.quantityLimit) {
      return 'Fully Redeemed';
    }
    return 'Promotion Expired';
  };

  useFocusEffect(
    useCallback(() => {
      getRealUserLocation();
    }, [])
  );

  const getRealUserLocation = async () => {
    if (Platform.OS === 'web') {
      await loadPromotionDetails(6.5244, 3.3792);
      return;
    }

    try {
      const { status } = await Location.requestForegroundPermissionsAsync();
      if (status !== 'granted') {
        await loadPromotionDetails(6.5244, 3.3792);
        return;
      }

      const location = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.High });
      const { latitude, longitude } = location.coords;
      setUserLat(latitude);
      setUserLng(longitude);
      await loadPromotionDetails(latitude, longitude);
    } catch (error) {
      await loadPromotionDetails(6.5244, 3.3792);
    }
  };

  const loadPromotionDetails = async (lat: number, lng: number) => {
    try {
      const [promotionsData, myRedemptions] = await Promise.all([
        apiService.getNearbyPromotions(lat, lng, 50),
        apiService.getMyRedemptions()
      ]);

      const found = promotionsData.find((p: any) => p.id === id);
      setPromotion(found);

      const hasGenerated = myRedemptions.some(
        (r: any) => r.promotion?.id === id && !r.isRedeemed
      );
      setQrGenerated(hasGenerated);
    } catch (error) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Failed to load promotion details' });
    } finally {
      setLoading(false);
    }
  };

  const handleGenerateQR = () => {
    if (isExpiredOrExhausted(promotion)) return;
    setSelectedQuantity(1);
    setShowQuantityModal(true);
  };

  const confirmGenerateQR = async () => {
    if (!promotion || selectedQuantity < 1) return;
    setShowQuantityModal(false);
    
    try {
      await apiService.generateQR({
        promotionId: promotion.id,
        quantity: selectedQuantity
      });

      setQrGenerated(true);

      Toast.show({ 
        type: 'success', 
        text1: 'QR Code Generated', 
        text2: `Quantity: ${selectedQuantity} × ${promotion.title}` 
      });
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Error', text2: error.message || 'Failed to generate QR code' });
    }
  };

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color="#1C8EDA" />
      </View>
    );
  }

  if (!promotion) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Promotion not found</Text>
      </View>
    );
  }

  const expiredOrExhausted = isExpiredOrExhausted(promotion);

  return (
    <ScrollView style={promotionStyles.container} showsVerticalScrollIndicator={false}>
      {promotion.photoUrl ? (
        <Image 
          source={{ uri: promotion.photoUrl }} 
          style={promotionStyles.heroImage}
          resizeMode="cover"
        />
      ) : (
        <View style={promotionStyles.heroPlaceholder}>
          <Text style={{ color: '#64748B', fontSize: 16 }}>No image available</Text>
        </View>
      )}

      <View style={promotionStyles.header}>
        <Text style={promotionStyles.title}>{promotion.title}</Text>
      </View>

      <View style={promotionStyles.card}>
        <View style={promotionStyles.priceContainer}>
          <Text style={promotionStyles.currentPrice}>₦{promotion.price}</Text>
          <Text style={promotionStyles.originalPrice}>₦{promotion.originalPrice}</Text>
        </View>

        <Text style={promotionStyles.merchantName}>
          {promotion.merchant?.businessName}
        </Text>

        <Text style={promotionStyles.metaText}>
          {promotion.distanceKm} km away • {estimateDriveTime(promotion.distanceKm)} • 
          {promotion.quantityLimit ? `${promotion.quantityLimit - (promotion.redeemedCount || 0)} left` : 'Unlimited'} 
        </Text>

        {!expiredOrExhausted && (
          <Text style={promotionStyles.metaText}>
            Expires {new Date(promotion.expiry).toLocaleDateString('en-NG')}
          </Text>
        )}

        {promotion.description && (
          <Text style={promotionStyles.description}>{promotion.description}</Text>
        )}

        {user && (
          <TouchableOpacity 
            onPress={handleGenerateQR}
            disabled={expiredOrExhausted}
            style={[
              promotionStyles.button, 
              expiredOrExhausted && { 
                backgroundColor: '#EF4444', 
                opacity: 0.7 
              }
            ]}
          >
            <Text style={promotionStyles.buttonText}>
              {expiredOrExhausted 
                ? getButtonText(promotion) 
                : 'Generate QR Code'}
            </Text>
          </TouchableOpacity>
        )}
      </View>

      <TouchableOpacity 
        onPress={() => router.back()}
        style={promotionStyles.backButton}
      >
        <Text style={{ color: '#1C8EDA', fontWeight: '600' }}>← Back to Home</Text>
      </TouchableOpacity>

      {/* Quantity Modal */}
      <Modal
        visible={showQuantityModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowQuantityModal(false)}
      >
        <View style={{ flex: 1, justifyContent: 'flex-end', backgroundColor: 'rgba(0,0,0,0.6)' }}>
          <View style={{
            backgroundColor: '#FFFFFF',
            borderTopLeftRadius: 24,
            borderTopRightRadius: 24,
            padding: 24,
            paddingBottom: 40
          }}>
            <Text style={{ fontSize: 22, fontWeight: '700', textAlign: 'center', marginBottom: 8 }}>
              How many would you like?
            </Text>
            <Text style={{ textAlign: 'center', color: '#64748B', marginBottom: 20 }}>
              {promotion.title} — ₦{promotion.price} each
            </Text>

            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 12, justifyContent: 'center', marginBottom: 24 }}>
              {[1, 3, 5, 10].map(q => (
                <TouchableOpacity
                  key={q}
                  onPress={() => setSelectedQuantity(q)}
                  style={{
                    paddingHorizontal: 24,
                    paddingVertical: 12,
                    borderRadius: 999,
                    borderWidth: 2,
                    borderColor: selectedQuantity === q ? '#1C8EDA' : '#E2E8F0',
                    backgroundColor: selectedQuantity === q ? '#F0F9FF' : '#FFFFFF'
                  }}
                >
                  <Text style={{ fontWeight: '600', color: selectedQuantity === q ? '#1C8EDA' : '#475569' }}>
                    {q}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            <Text style={{ fontSize: 15, color: '#64748B', marginBottom: 8, textAlign: 'center' }}>
              Or type any number
            </Text>
            <TextInput
              style={{
                borderWidth: 1,
                borderColor: '#1C8EDA',
                borderRadius: 12,
                padding: 14,
                fontSize: 18,
                textAlign: 'center',
                marginBottom: 24
              }}
              placeholder="Enter quantity"
              keyboardType="numeric"
              value={selectedQuantity > 0 ? selectedQuantity.toString() : ''}
              onChangeText={(text) => {
                const num = parseInt(text) || 0;
                setSelectedQuantity(num);
              }}
            />

            <TouchableOpacity 
              onPress={confirmGenerateQR}
              style={{
                backgroundColor: '#1C8EDA',
                paddingVertical: 18,
                borderRadius: 999,
                alignItems: 'center',
                marginBottom: 12
              }}
            >
              <Text style={{ color: 'white', fontSize: 18, fontWeight: '600' }}>
                Generate QR for {selectedQuantity} item{selectedQuantity > 1 ? 's' : ''}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity 
              onPress={() => setShowQuantityModal(false)}
              style={{ paddingVertical: 12 }}
            >
              <Text style={{ textAlign: 'center', color: '#64748B', fontWeight: '600' }}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </ScrollView>
  );
}