import React, { useState, useEffect } from 'react';
import { ScrollView, View, Text, TouchableOpacity, Alert, ActivityIndicator, Image } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useAuth } from '../../context/AuthContext';
import { apiService } from '../../services/api';
import { promotionStyles } from '../../styles/promotion.styles';

export default function PromotionDetail() {
  const router = useRouter();
  const { id } = useLocalSearchParams<{ id: string }>();
  const { user } = useAuth();

  const [promotion, setPromotion] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (id) loadPromotionDetails(id);
  }, [id]);

  const loadPromotionDetails = async (promotionId: string) => {
    try {
      const promotions = await apiService.getNearbyPromotions(6.5, 3.4, 50);
      const found = promotions.find((p: any) => p.id === promotionId);
      setPromotion(found);
    } catch (error) {
      Alert.alert("Error", "Failed to load promotion details");
    } finally {
      setLoading(false);
    }
  };

  const handleGenerateQR = () => {
    router.push({
      pathname: '/redemption/generate',
      params: { promotionId: id }
    });
  };

  if (loading) {
    return <ActivityIndicator size="large" style={{ flex: 1 }} color="#1C8EDA" />;
  }

  if (!promotion) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Promotion not found</Text>
      </View>
    );
  }

  return (
    <ScrollView style={promotionStyles.container} showsVerticalScrollIndicator={false}>
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
          {promotion.distanceKm}km away • Expires {new Date(promotion.expiry).toLocaleDateString('en-NG')}
        </Text>

        {promotion.description && (
          <Text style={promotionStyles.description}>{promotion.description}</Text>
        )}

        {/* Generate QR Button */}
        {user && (
          <TouchableOpacity 
            onPress={handleGenerateQR}
            style={promotionStyles.button}
          >
            <Text style={promotionStyles.buttonText}>
              Generate QR Code
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
    </ScrollView>
  );
}