import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  StyleSheet,
} from 'react-native';
import { CameraView, useCameraPermissions, BarcodeScanningResult } from 'expo-camera';
import { useRouter } from 'expo-router';
import { useAuth } from '../context/AuthContext';
import { apiService } from '../services/api';
import { useMerchant } from '../context/MerchantContext';


export default function ScanScreen() {
  const router = useRouter();
  const { user, isSignedIn } = useAuth();

  const [permission, requestPermission] = useCameraPermissions();
  const [scanned, setScanned] = useState(false);
  const [loading, setLoading] = useState(false);
  const { refreshAnalytics } = useMerchant();

  const isProcessingRef = useRef(false);

  useEffect(() => {
    if (!isSignedIn || user?.role !== 'MERCHANT') {
      Alert.alert('Access Denied', 'This feature is only for registered merchants.', [
        { text: 'Go Back', onPress: () => router.replace('/(tabs)/home') },
      ]);
    }
  }, [isSignedIn, user]);

  const handleBarCodeScanned = async (result: BarcodeScanningResult) => {
    if (scanned || isProcessingRef.current || !result.data) return;

    isProcessingRef.current = true;
    setScanned(true);
    setLoading(true);

    try {
      const response = await apiService.redeem(result.data);
      await refreshAnalytics();

      const analytics = await apiService.getMerchantAnalytics();
      console.log('🔥 [SCAN] Merchant analytics after redemption:', JSON.stringify(analytics, null, 2));

      Alert.alert(
        '✅ Redemption Successful!',
        `Promotion redeemed.\n3% fee (₦${response.successFeeCharged || '405'}) added to balance.`,
        [
          {
            text: 'Scan Another',
            onPress: () => {
              setScanned(false);
              isProcessingRef.current = false;
            },
          },
          {
            text: 'Back to Dashboard',
            onPress: () => router.replace('/merchants/promotions'),
          },
        ]
      );
    } catch (error: any) {
      console.error('Redemption error:', error);
      Alert.alert('Redemption Failed', error.message || 'Invalid or already redeemed QR code.', [
        { text: 'Try Again', onPress: () => {
          setScanned(false);
          isProcessingRef.current = false;
        }},
      ]);
    } finally {
      setLoading(false);
    }
  };

  if (!permission) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color="#1C8EDA" />
      </View>
    );
  }

  if (!permission.granted) {
    return (
      <View style={styles.center}>
        <Text style={{ fontSize: 18, color: '#EF4444', textAlign: 'center' }}>
          We need camera permission to scan QR codes
        </Text>
        <TouchableOpacity
          onPress={requestPermission}
          style={{
            marginTop: 20,
            backgroundColor: '#1C8EDA',
            paddingHorizontal: 24,
            paddingVertical: 12,
            borderRadius: 999,
          }}
        >
          <Text style={{ color: '#FFFFFF', fontWeight: '600' }}>Grant Permission</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <CameraView
        style={StyleSheet.absoluteFillObject}
        facing="back"
        onBarcodeScanned={scanned ? undefined : handleBarCodeScanned}
        barcodeScannerSettings={{
          barcodeTypes: ['qr'],
        }}
      />

      <View style={styles.overlay}>
        <View style={styles.scanFrame} />
        <Text style={styles.instruction}>
          Point camera at customer’s QR code
        </Text>
      </View>

      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#FFFFFF" />
          <Text style={{ color: '#FFFFFF', marginTop: 12 }}>Processing redemption...</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000' },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#F8FAFC' },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
    alignItems: 'center',
  },
  scanFrame: {
    width: 260,
    height: 260,
    borderWidth: 4,
    borderColor: '#1C8EDA',
    borderRadius: 16,
  },
  instruction: {
    marginTop: 30,
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: '600',
    textAlign: 'center',
  },
  loadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.85)',
    justifyContent: 'center',
    alignItems: 'center',
  },
});