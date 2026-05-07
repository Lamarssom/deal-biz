import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, Alert, ScrollView, ActivityIndicator, Image } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { apiService } from '../../services/api';

export default function GenerateQR() {
  const router = useRouter();
  const { promotionId } = useLocalSearchParams<{ promotionId: string }>();

  const [loading, setLoading] = useState(true);
  const [qrData, setQrData] = useState<any>(null);

  useEffect(() => {
    if (promotionId) {
      generateQRCode();
    } else {
      Alert.alert("Error", "No promotion selected");
      router.back();
    }
  }, [promotionId]);

  const generateQRCode = async () => {
    try {
      const response = await apiService.generateQR({ promotionId });
      setQrData(response);
    } catch (error: any) {
      Alert.alert("Error", error?.message || "Failed to generate QR code");
      router.back();
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color="#1C8EDA" />
        <Text style={{ marginTop: 16 }}>Generating QR Code...</Text>
      </View>
    );
  }

  return (
    <ScrollView style={{ flex: 1, backgroundColor: '#F8FAFC', padding: 20 }}>
      <Text style={{ fontSize: 24, fontWeight: '700', textAlign: 'center', marginBottom: 8 }}>
        Your QR Code
      </Text>
      <Text style={{ textAlign: 'center', color: '#64748B', marginBottom: 24 }}>
        Show this QR code to the merchant when redeeming
      </Text>

      {qrData?.qrImage && (
        <View style={{ alignItems: 'center', backgroundColor: 'white', padding: 20, borderRadius: 16, marginBottom: 24 }}>
          <Image 
            source={{ uri: qrData.qrImage }} 
            style={{ width: 280, height: 280 }} 
          />
        </View>
      )}

      <Text style={{ fontSize: 16, fontWeight: '600', marginBottom: 8 }}>Promotion:</Text>
      <Text style={{ fontSize: 18 }}>{qrData?.promotionTitle || 'Promotion'}</Text>

      <TouchableOpacity 
        onPress={() => router.back()}
        style={{
          backgroundColor: '#1C8EDA',
          padding: 16,
          borderRadius: 12,
          alignItems: 'center',
          marginTop: 30
        }}
      >
        <Text style={{ color: 'white', fontWeight: '600', fontSize: 16 }}>
          Done
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
}