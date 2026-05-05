import React, { useState, useEffect } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  Alert, 
  TextInput, 
  Platform, 
  Modal 
} from 'react-native';
import { useRouter } from 'expo-router';
import DateTimePicker from '@react-native-community/datetimepicker';
import WebView from 'react-native-webview';

import { promotionsStyles } from '../../styles/promotions.styles';
import { useAuth } from '../../context/AuthContext';
import { apiService, CreatePromotionPayload } from '../../services/api';

export default function MerchantPromotionsScreen() {
  const router = useRouter();
  const { user } = useAuth();

  const [loading, setLoading] = useState(false);
  const [actionLoading, setActionLoading] = useState(false);
  const [analyticsLoading, setAnalyticsLoading] = useState(true);

  const [outstandingBalance, setOutstandingBalance] = useState<number>(0);
  const [settleAmount, setSettleAmount] = useState('50');

  const [showDatePicker, setShowDatePicker] = useState(false);
  
  // WebView Payment States
  const [showPaymentWebView, setShowPaymentWebView] = useState(false);
  const [paymentUrl, setPaymentUrl] = useState<string>('');

  const today = new Date();
  const maxExpiryDate = new Date();
  maxExpiryDate.setDate(maxExpiryDate.getDate() + 7);

  const [formData, setFormData] = useState<CreatePromotionPayload>({
    type: "STANDARD",
    title: "",
    price: 0,
    originalPrice: 0,
    expiry: maxExpiryDate.toISOString(),
    quantityLimit: 10,
    description: "",
  });

  // Load Merchant Analytics
  useEffect(() => {
    loadAnalytics();
  }, []);

  const loadAnalytics = async () => {
    try {
      const analytics = await apiService.getMerchantAnalytics();
      const balance = analytics?.outstandingBalance ?? 0;
      setOutstandingBalance(typeof balance === 'number' ? balance : 0);
    } catch (error) {
      console.log('Failed to load analytics', error);
      setOutstandingBalance(0);
    } finally {
      setAnalyticsLoading(false);
    }
  };

  const handleDateChange = (event: any, selectedDate?: Date) => {
    setShowDatePicker(Platform.OS === 'ios');
    if (selectedDate) {
      if (selectedDate > maxExpiryDate) {
        Alert.alert("Limit Reached", "Promotions cannot exceed 7 days.");
        return;
      }
      setFormData(prev => ({ ...prev, expiry: selectedDate.toISOString() }));
    }
  };

  // === CREATE PROMOTION + OPEN PAYSTACK IN APP ===
  const handleCreatePromotion = async () => {
    if (!formData.title?.trim() || formData.price <= 0 || formData.originalPrice <= 0) {
      Alert.alert("Error", "Please fill all required fields correctly");
      return;
    }

    setLoading(true);
    try {
      const response = await apiService.createPromotionWithPayment(formData);

      if (response?.authorizationUrl) {
        setPaymentUrl(response.authorizationUrl);
        setShowPaymentWebView(true);
      } else {
        Alert.alert("Error", "No payment URL received from server");
      }
    } catch (error: any) {
      Alert.alert('Error', error?.message || 'Failed to create promotion');
    } finally {
      setLoading(false);
    }
  };

  // === SETTLE BALANCE ===
  const handleSettleBalance = async () => {
    const amount = parseFloat(settleAmount);
    if (!amount || amount <= 0) {
      Alert.alert("Error", "Please enter a valid amount");
      return;
    }

    setActionLoading(true);
    try {
      await apiService.settleMerchantBalance({ amount });
      Alert.alert('Success', `₦${amount} settlement initiated successfully!`);
      
      setSettleAmount('50');
      loadAnalytics(); // Refresh balance
    } catch (error: any) {
      Alert.alert('Error', error?.message || 'Failed to settle balance');
    } finally {
      setActionLoading(false);
    }
  };

  // Handle WebView Navigation (Optional - detects success/cancel)
  const handleWebViewNavigationStateChange = (navState: any) => {
    const { url } = navState;
    if (url.includes('success') || url.includes('callback') || url.includes('thank')) {
      setTimeout(() => {
        setShowPaymentWebView(false);
        Alert.alert("Payment Successful!", "Your promotion will be activated shortly.");
        loadAnalytics();
      }, 1500);
    }
  };

  return (
    <ScrollView style={promotionsStyles.container} showsVerticalScrollIndicator={false}>
      <View style={promotionsStyles.header}>
        <Text style={promotionsStyles.title}>Merchant Dashboard</Text>
        <Text style={promotionsStyles.subtitle}>Create promotions & manage account</Text>
      </View>

      {/* Outstanding Balance */}
      <View style={promotionsStyles.card}>
        <Text style={{ fontSize: 18, fontWeight: '700', marginBottom: 8 }}>Outstanding Balance</Text>
        <Text style={{ fontSize: 32, fontWeight: '700', color: '#1C8EDA' }}>
          ₦{analyticsLoading ? '---' : outstandingBalance.toFixed(2)}
        </Text>
        <Text style={{ color: '#64748B', marginTop: 4 }}>Current debt</Text>
      </View>

      {/* Create Promotion Form */}
      <View style={promotionsStyles.card}>
        <Text style={{ fontSize: 20, fontWeight: '700', marginBottom: 16 }}>Create New Promotion</Text>

        <Text style={{ fontWeight: '600', marginBottom: 8 }}>Promotion Type</Text>
        <View style={[promotionsStyles.input, { justifyContent: 'center' }]}>
          <Text style={{ fontSize: 16, color: '#1C8EDA', fontWeight: '600' }}>STANDARD</Text>
        </View>

        <TextInput
          style={promotionsStyles.input}
          placeholder="Promotion Title *"
          value={formData.title}
          onChangeText={(text) => setFormData({ ...formData, title: text })}
        />

        <TextInput
          style={[promotionsStyles.input, { height: 80 }]}
          placeholder="Description (optional)"
          value={formData.description}
          onChangeText={(text) => setFormData({ ...formData, description: text })}
          multiline
        />

        <TextInput
          style={promotionsStyles.input}
          placeholder="Selling Price (₦) *"
          keyboardType="numeric"
          value={formData.price ? formData.price.toString() : ''}
          onChangeText={(text) => setFormData({ ...formData, price: Number(text) || 0 })}
        />

        <TextInput
          style={promotionsStyles.input}
          placeholder="Original Price (₦) *"
          keyboardType="numeric"
          value={formData.originalPrice ? formData.originalPrice.toString() : ''}
          onChangeText={(text) => setFormData({ ...formData, originalPrice: Number(text) || 0 })}
        />

        <TextInput
          style={promotionsStyles.input}
          placeholder="Quantity Limit *"
          keyboardType="numeric"
          value={formData.quantityLimit.toString()}
          onChangeText={(text) => setFormData({ ...formData, quantityLimit: Number(text) || 10 })}
        />

        <Text style={{ fontWeight: '600', marginTop: 12, marginBottom: 8 }}>Expiry Date (Max 7 days)</Text>
        <TouchableOpacity 
          style={[promotionsStyles.input, { justifyContent: 'center' }]} 
          onPress={() => setShowDatePicker(true)}
        >
          <Text style={{ fontSize: 16 }}>
            {new Date(formData.expiry).toLocaleDateString('en-NG', {
              weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
            })}
          </Text>
        </TouchableOpacity>

        {showDatePicker && (
          <DateTimePicker
            value={new Date(formData.expiry)}
            mode="date"
            display={Platform.OS === 'ios' ? 'spinner' : 'calendar'}
            minimumDate={today}
            maximumDate={maxExpiryDate}
            onChange={handleDateChange}
          />
        )}

        <TouchableOpacity 
          style={promotionsStyles.actionButton} 
          onPress={handleCreatePromotion}
          disabled={loading}
        >
          <Text style={promotionsStyles.actionButtonText}>
            {loading ? "Processing..." : "Create Promotion & Pay ₦25"}
          </Text>
        </TouchableOpacity>
      </View>

      {/* Settle Balance */}
      <View style={promotionsStyles.card}>
        <Text style={{ fontSize: 18, fontWeight: '700', marginBottom: 16 }}>Settle Balance</Text>
        
        <TextInput
          style={promotionsStyles.input}
          placeholder="Amount to settle (₦)"
          keyboardType="numeric"
          value={settleAmount}
          onChangeText={setSettleAmount}
        />

        <TouchableOpacity 
          style={[promotionsStyles.actionButton, { backgroundColor: '#1C8EDA' }]} 
          onPress={handleSettleBalance}
          disabled={actionLoading}
        >
          <Text style={promotionsStyles.actionButtonText}>
            {actionLoading ? "Processing..." : `Settle ₦${settleAmount}`}
          </Text>
        </TouchableOpacity>
      </View>

      <Modal
        visible={showPaymentWebView}
        animationType="slide"
        presentationStyle="pageSheet"
        onRequestClose={() => setShowPaymentWebView(false)}
      >
        <View style={{ flex: 1, backgroundColor: '#fff' }}>
          <View style={{ 
            padding: 16, 
            backgroundColor: '#1C8EDA', 
            flexDirection: 'row', 
            justifyContent: 'space-between',
            alignItems: 'center'
          }}>
            <Text style={{ color: 'white', fontSize: 18, fontWeight: '600' }}>
              Complete Payment
            </Text>
            <TouchableOpacity onPress={() => setShowPaymentWebView(false)}>
              <Text style={{ color: 'white', fontSize: 16, fontWeight: '600' }}>Close</Text>
            </TouchableOpacity>
          </View>

          <WebView
            source={{ uri: paymentUrl }}
            style={{ flex: 1 }}
            onNavigationStateChange={handleWebViewNavigationStateChange}
            startInLoadingState={true}
            javaScriptEnabled={true}
          />
        </View>
      </Modal>
    </ScrollView>
  );
}