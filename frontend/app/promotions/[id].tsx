import React, { useState, useEffect } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  Alert, 
  ActivityIndicator, 
  TextInput,
  Modal,
  Image
} from 'react-native';
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

  // Quantity selector states
  const [showQuantityModal, setShowQuantityModal] = useState(false);
  const [selectedQuantity, setSelectedQuantity] = useState(1);

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
    setShowQuantityModal(true);
  };

  const confirmGenerateQR = async () => {
    if (!promotion) return;
    
    setShowQuantityModal(false);
    
    try {
      const response = await apiService.generateQR({
        promotionId: promotion.id,
        quantity: selectedQuantity
      });

      Alert.alert(
        "QR Code Generated", 
        `Quantity: ${selectedQuantity} × ${promotion.title}`,
        [
          { text: "View My Vouchers", onPress: () => router.push('/redemptions') },
          { text: "OK", style: "cancel" }
        ]
      );
    } catch (error: any) {
      Alert.alert("Error", error.message || "Failed to generate QR code");
    }
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
      {/* LARGE PROMOTION IMAGE */}
      {promotion.photoUrl ? (
        <Image 
          source={{ uri: promotion.photoUrl }} 
          style={{ width: '100%', height: 240, resizeMode: 'cover' }}
        />
      ) : (
        <View style={{ 
          height: 240, 
          backgroundColor: '#E2E8F0', 
          justifyContent: 'center', 
          alignItems: 'center' 
        }}>
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

        {/* MERCHANT PHONE NUMBER */}
        {promotion.merchant?.phoneNumber && (
          <Text style={{ color: '#10B981', fontWeight: '600', marginTop: 4 }}>
            📞 {promotion.merchant.phoneNumber}
          </Text>
        )}

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

      {/* Quantity Selection Modal */}
      <Modal
        visible={showQuantityModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowQuantityModal(false)}
      >
        <View style={{
          flex: 1,
          justifyContent: 'flex-end',
          backgroundColor: 'rgba(0,0,0,0.6)'
        }}>
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
            <Text style={{ textAlign: 'center', color: '#64748B', marginBottom: 24 }}>
              {promotion.title} — ₦{promotion.price} each
            </Text>

            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 12, justifyContent: 'center', marginBottom: 24 }}>
              {[1, 2, 3, 5, 10].map(q => (
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