import React, { useState, useEffect, useCallback } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TouchableOpacity, 
  TextInput, 
  Platform, 
  Modal,
  ActivityIndicator,
  Image,
  RefreshControl
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import * as ImagePicker from 'expo-image-picker';
import DateTimePicker from '@react-native-community/datetimepicker';
import WebView from 'react-native-webview';
import Toast from 'react-native-toast-message';

import { promotionsStyles } from '../../styles/promotions.styles';
import { useAuth } from '../../context/AuthContext';
import { apiService, CreatePromotionPayload } from '../../services/api';
import { useMerchant } from '../../context/MerchantContext';

// UI Components
import { LoadingSkeleton } from '../../components/ui/LoadingSkeleton';
import { ErrorState } from '../../components/ui/ErrorState';
import { EmptyState } from '../../components/ui/EmptyState';

export default function MerchantPromotionsScreen() {
  const router = useRouter();
  const { user } = useAuth();
  const { analytics, loading: analyticsLoading, refreshAnalytics } = useMerchant();

  const [activeTab, setActiveTab] = useState<'overview' | 'create' | 'my'>('overview');

  const [myPromotions, setMyPromotions] = useState<any[]>([]);
  const [myPromotionsLoading, setMyPromotionsLoading] = useState(false);
  const [myPromotionsError, setMyPromotionsError] = useState<string | null>(null);

  const [loading, setLoading] = useState(false);
  const [actionLoading, setActionLoading] = useState(false);

  const [settleAmount, setSettleAmount] = useState('100');

  const [showDatePicker, setShowDatePicker] = useState(false);
  const [showPaymentWebView, setShowPaymentWebView] = useState(false);
  const [paymentUrl, setPaymentUrl] = useState<string>('');

  const [showEditModal, setShowEditModal] = useState(false);
  const [selectedPromo, setSelectedPromo] = useState<any>(null);
  const [newQuantityLimit, setNewQuantityLimit] = useState(0);

  // Max 7 days from today
  const today = new Date();
  const maxExpiryDate = new Date();
  maxExpiryDate.setDate(maxExpiryDate.getDate() + 7);

  const [formData, setFormData] = useState<CreatePromotionPayload>({
    type: "STANDARD",
    title: "",
    price: 0,
    originalPrice: 0,
    expiry: maxExpiryDate.toISOString(),
    quantityLimit: 0,
    description: "",
    photoUrl: "",
  });

  useFocusEffect(
    useCallback(() => {
      if (activeTab === 'overview') refreshAnalytics();
      if (activeTab === 'my') loadMyPromotions();
    }, [activeTab])
  );

  const loadMyPromotions = async () => {
    setMyPromotionsLoading(true);
    setMyPromotionsError(null);
    try {
      const promotions = await apiService.getMyPromotions();
      setMyPromotions(promotions);
    } catch (err: any) {
      setMyPromotionsError('Could not load your promotions. Pull down to retry.');
    } finally {
      setMyPromotionsLoading(false);
    }
  };

  const retryMyPromotions = () => {
    setMyPromotionsError(null);
    loadMyPromotions();
  };

  const openEditModal = (promo: any) => {
    const isExpired = new Date(promo.expiry) < new Date();
    const isFullyRedeemed = promo.quantityLimit && promo.redeemedCount >= promo.quantityLimit;

    if (isExpired || isFullyRedeemed) {
      Toast.show({
        type: 'error',
        text1: 'Cannot Edit',
        text2: isFullyRedeemed ? 'This promotion is fully redeemed' : 'This promotion has expired'
      });
      return;
    }

    setSelectedPromo(promo);
    setNewQuantityLimit(promo.quantityLimit);
    setShowEditModal(true);
  };

  const handleUpdateQuantity = async () => {
    if (!selectedPromo) return;

    // Prevent going below redeemed count
    if (newQuantityLimit < selectedPromo.redeemedCount) {
      Toast.show({ 
        type: 'error', 
        text1: 'Invalid Quantity', 
        text2: `Cannot set below redeemed count (${selectedPromo.redeemedCount})` 
      });
      return;
    }

    // NEW: Only allow reduction (strictly less than current)
    if (newQuantityLimit >= selectedPromo.quantityLimit) {
      Toast.show({ 
        type: 'error', 
        text1: 'Cannot Increase', 
        text2: 'You can only reduce the quantity limit, not increase or keep it the same.' 
      });
      return;
    }

    setActionLoading(true);
    try {
      await apiService.updatePromotionQuantity(selectedPromo.id, newQuantityLimit);
      
      Toast.show({ 
        type: 'success', 
        text1: 'Quantity Reduced!', 
        text2: `From ${selectedPromo.quantityLimit} → ${newQuantityLimit} (permanent)` 
      });
      
      setShowEditModal(false);
      loadMyPromotions(); // Refresh list
    } catch (error: any) {
      Toast.show({ 
        type: 'error', 
        text1: 'Update Failed', 
        text2: error?.message || 'Could not update quantity' 
      });
    } finally {
      setActionLoading(false);
    }
  };
  

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      aspect: [4, 3],
      quality: 0.8,
    });

    if (!result.canceled && result.assets?.[0]) {
      setFormData(prev => ({ ...prev, photoUrl: result.assets[0].uri }));
    }
  };

  const handleDateChange = (event: any, selectedDate?: Date) => {
    setShowDatePicker(Platform.OS === 'ios');
    if (selectedDate) {
      // Enforce max 7 days
      if (selectedDate > maxExpiryDate) {
        Toast.show({ type: 'error', text1: 'Limit Reached', text2: 'Promotions cannot exceed 7 days from today.' });
        return;
      }
      setFormData(prev => ({ ...prev, expiry: selectedDate.toISOString() }));
    }
  };

  const handleCreatePromotion = async () => {
    if (!formData.title?.trim() || formData.price <= 0 || formData.originalPrice <= 0 || formData.quantityLimit <= 0) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Please fill all required fields correctly' });
      return;
    }

    setLoading(true);
    try {
      let finalPhotoUrl = formData.photoUrl;

      if (finalPhotoUrl && finalPhotoUrl.startsWith('file://')) {
        finalPhotoUrl = await apiService.uploadImageToCloudinary(finalPhotoUrl);
      }

      const payload = { ...formData, photoUrl: finalPhotoUrl };

      const response = await apiService.createPromotionWithPayment(payload);
      if (response?.authorizationUrl) {
        setPaymentUrl(response.authorizationUrl);
        setShowPaymentWebView(true);
      }
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Error', text2: error?.message || 'Failed to create promotion' });
    } finally {
      setLoading(false);
    }
  };

  const handleSettleBalance = async () => {
    const amount = parseFloat(settleAmount);
    if (!amount || amount <= 0) {
      Toast.show({ type: 'error', text1: 'Error', text2: 'Please enter a valid amount' });
      return;
    }

    setActionLoading(true);
    try {
      const response = await apiService.settleMerchantBalance({ amount });

      if (response?.authorizationUrl) {
        setPaymentUrl(response.authorizationUrl);
        setShowPaymentWebView(true);
      }
    } catch (error: any) {
      Toast.show({ type: 'error', text1: 'Error', text2: error?.message || 'Failed to initiate settlement' });
    } finally {
      setActionLoading(false);
    }
  };

  const handleWebViewNavigationStateChange = (navState: any) => {
    if (navState.url.includes('success') || navState.url.includes('callback')) {
      setTimeout(() => {
        setShowPaymentWebView(false);
        Toast.show({ type: 'success', text1: 'Settlement Successful!', text2: 'Your balance has been updated.' });
        refreshAnalytics();
        setActiveTab('overview');
      }, 1500);
    }
  };

  return (
    <ScrollView 
      style={promotionsStyles.container} 
      showsVerticalScrollIndicator={false}
      refreshControl={
        <RefreshControl 
          refreshing={analyticsLoading || myPromotionsLoading} 
          onRefresh={() => {
            if (activeTab === 'overview') refreshAnalytics();
            if (activeTab === 'my') loadMyPromotions();
          }} 
        />
      }
    >
      <View style={promotionsStyles.header}>
        <Text style={promotionsStyles.title}>Dashboard</Text>
        <Text style={promotionsStyles.subtitle}>Manage promotions & account</Text>
      </View>

      <View style={promotionsStyles.tabContainer}>
        <TouchableOpacity 
          style={[promotionsStyles.tab, activeTab === 'overview' && promotionsStyles.tabActive]}
          onPress={() => setActiveTab('overview')}
        >
          <Text style={[promotionsStyles.tabText, activeTab === 'overview' && promotionsStyles.tabTextActive]}>
            Overview
          </Text>
        </TouchableOpacity>

        <TouchableOpacity 
          style={[promotionsStyles.tab, activeTab === 'create' && promotionsStyles.tabActive]}
          onPress={() => setActiveTab('create')}
        >
          <Text style={[promotionsStyles.tabText, activeTab === 'create' && promotionsStyles.tabTextActive]}>
            Create
          </Text>
        </TouchableOpacity>

        <TouchableOpacity 
          style={[promotionsStyles.tab, activeTab === 'my' && promotionsStyles.tabActive]}
          onPress={() => setActiveTab('my')}
        >
          <Text style={[promotionsStyles.tabText, activeTab === 'my' && promotionsStyles.tabTextActive]}>
            My Promotions
          </Text>
        </TouchableOpacity>
      </View>

      {/* OVERVIEW TAB */}
      {activeTab === 'overview' && (
        <>
          <View style={promotionsStyles.card}>
            <Text style={{ fontSize: 18, fontWeight: '700', marginBottom: 8 }}>Outstanding Balance</Text>
            {analyticsLoading ? (
              <LoadingSkeleton />
            ) : (
              <>
                <Text style={{ fontSize: 36, fontWeight: '700', color: '#1C8EDA' }}>
                  ₦{(analytics?.outstandingBalance ?? 0).toFixed(2)}
                </Text>
                <Text style={{ color: '#64748B' }}>Current debt</Text>
              </>
            )}
          </View>

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
              style={promotionsStyles.actionButton} 
              onPress={handleSettleBalance}
              disabled={actionLoading}
            >
              <Text style={promotionsStyles.actionButtonText}>
                {actionLoading ? "Processing..." : `Settle ₦${settleAmount}`}
              </Text>
            </TouchableOpacity>
          </View>
        </>
      )}

      {/* CREATE TAB - Reverted to DateTimePicker with 7-day max */}
      {activeTab === 'create' && (
        <View style={promotionsStyles.card}>
          <Text style={{ fontSize: 20, fontWeight: '700', marginBottom: 20 }}>Create New Promotion</Text>

          <TouchableOpacity 
            onPress={pickImage}
            style={{
              height: 180,
              backgroundColor: '#F1F5F9',
              borderRadius: 16,
              justifyContent: 'center',
              alignItems: 'center',
              marginBottom: 20,
              borderWidth: 2,
              borderColor: '#E2E8F0',
              borderStyle: 'dashed'
            }}
          >
            {formData.photoUrl ? (
              <Image source={{ uri: formData.photoUrl }} style={{ width: '100%', height: '100%', borderRadius: 16 }} resizeMode="cover" />
            ) : (
              <Text style={{ color: '#64748B' }}>Tap to add promotion photo (optional)</Text>
            )}
          </TouchableOpacity>

          <Text style={promotionsStyles.label}>Promotion Title *</Text>
          <TextInput
            style={promotionsStyles.input}
            placeholder="e.g. 50% off Pizza"
            value={formData.title}
            onChangeText={(text) => setFormData({ ...formData, title: text })}
          />

          <Text style={promotionsStyles.label}>Description (optional)</Text>
          <TextInput
            style={[promotionsStyles.input, { height: 100 }]}
            placeholder="Brief description..."
            value={formData.description}
            onChangeText={(text) => setFormData({ ...formData, description: text })}
            multiline
          />

          <Text style={promotionsStyles.label}>Selling Price (₦) *</Text>
          <TextInput
            style={promotionsStyles.input}
            placeholder="2500"
            keyboardType="numeric"
            value={formData.price ? formData.price.toString() : ''}
            onChangeText={(text) => setFormData({ ...formData, price: Number(text) || 0 })}
          />

          <Text style={promotionsStyles.label}>Original Price (₦) *</Text>
          <TextInput
            style={promotionsStyles.input}
            placeholder="5000"
            keyboardType="numeric"
            value={formData.originalPrice ? formData.originalPrice.toString() : ''}
            onChangeText={(text) => setFormData({ ...formData, originalPrice: Number(text) || 0 })}
          />

          <Text style={promotionsStyles.label}>Quantity Limit *</Text>
          <TextInput
            style={promotionsStyles.input}
            placeholder="e.g. 15 (how many items can be redeemed)"
            keyboardType="numeric"
            value={formData.quantityLimit ? formData.quantityLimit.toString() : ''}
            onChangeText={(text) => setFormData({ ...formData, quantityLimit: Number(text) || 0 })}
          />

          <Text style={promotionsStyles.label}>Expiry Date (max 7 days from today)</Text>
          <TouchableOpacity 
            style={[promotionsStyles.input, { justifyContent: 'center' }]} 
            onPress={() => setShowDatePicker(true)}
          >
            <Text style={{ fontSize: 16 }}>
              {new Date(formData.expiry).toLocaleDateString('en-NG', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
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
      )}

            {/* MY PROMOTIONS TAB */}
      {activeTab === 'my' && (
        <View style={{ paddingHorizontal: 20 }}>
          <Text style={{ fontSize: 20, fontWeight: '700', marginBottom: 16 }}>My Promotions</Text>

          {myPromotionsLoading && <LoadingSkeleton />}

          {myPromotionsError && <ErrorState message={myPromotionsError} onRetry={retryMyPromotions} />}

          {!myPromotionsLoading && !myPromotionsError && myPromotions.length === 0 && (
            <EmptyState 
              icon="package" 
              title="No promotions yet" 
              subtitle="Create your first promotion to get started" 
            />
          )}

          {!myPromotionsLoading && !myPromotionsError && myPromotions.map((promo) => {
            const isExpired = new Date(promo.expiry) < new Date();
            const isFullyRedeemed = promo.quantityLimit && promo.redeemedCount >= promo.quantityLimit;
            return (
              <View key={promo.id} style={promotionsStyles.card}>
                <Text style={{ fontSize: 18, fontWeight: '600' }}>{promo.title}</Text>
                <Text style={{ color: '#64748B' }}>
                  {promo.merchant?.businessName || 'Your Business'}
                </Text>

                <View style={{ flexDirection: 'row', marginVertical: 12, gap: 12 }}>
                  <Text style={{ color: '#1C8EDA', fontWeight: '700', fontSize: 22 }}>
                    ₦{promo.price}
                  </Text>
                  <Text style={{ textDecorationLine: 'line-through', color: '#94A3B8', fontSize: 18 }}>
                    ₦{promo.originalPrice}
                  </Text>
                </View>

                {!isExpired && !isFullyRedeemed && (
                  <Text style={{ color: '#10B981', fontWeight: '600' }}>
                    Expires: {new Date(promo.expiry).toLocaleDateString('en-NG')}
                  </Text>
                )}

                <Text style={{ 
                  marginTop: 8, 
                  color: (isExpired || isFullyRedeemed) ? '#EF4444' : '#10B981',
                  fontWeight: '600'
                }}>
                  {(isExpired || isFullyRedeemed) ? 'Expired' : 'Active'}
                </Text>

                <Text style={{ color: '#64748B', fontSize: 13 }}>
                  Redeemed: {promo.redeemedCount || 0} / {promo.quantityLimit || '∞'}
                </Text>

                {/* EDIT BUTTON */}
                <TouchableOpacity 
                  style={{
                    marginTop: 12,
                    paddingVertical: 10,
                    borderWidth: 1,
                    borderColor: (isExpired || isFullyRedeemed) ? '#EF4444' : '#1C8EDA',
                    borderRadius: 999,
                    alignItems: 'center',
                    opacity: (isExpired || isFullyRedeemed) ? 0.6 : 1
                  }}
                  onPress={() => openEditModal(promo)}
                  disabled={isExpired || isFullyRedeemed}
                >
                  <Text style={{ color: '#1C8EDA', fontWeight: '600' }}>Edit Remaining Quantity</Text>
                </TouchableOpacity>
              </View>
            );
          })}
        </View>
      )}

            {/* EDIT QUANTITY MODAL - HALF SCREEN */}
      <Modal
        visible={showEditModal}
        transparent={true}
        animationType="slide"
        onRequestClose={() => setShowEditModal(false)}
      >
        <View style={{
          flex: 1,
          justifyContent: 'flex-end',
          backgroundColor: 'rgba(0, 0, 0, 0.5)', // dark overlay
        }}>
          <View style={{
            backgroundColor: '#fff',
            borderTopLeftRadius: 24,
            borderTopRightRadius: 24,
            padding: 24,
            maxHeight: '62%',           // ← tweak this if you want it taller/shorter
          }}>
            <Text style={{ fontSize: 22, fontWeight: '700', marginBottom: 20 }}>
              Reduce Quantity Limit
            </Text>

            {selectedPromo && (
              <>
                <Text style={{ fontSize: 16, color: '#64748B', marginBottom: 8 }}>
                  Promotion: <Text style={{ fontWeight: '600', color: '#0F172A' }}>{selectedPromo.title}</Text>
                </Text>

                <Text style={{ fontSize: 16, color: '#64748B', marginBottom: 8 }}>
                  Currently Redeemed: <Text style={{ fontWeight: '600' }}>{selectedPromo.redeemedCount}</Text>
                </Text>

                <Text style={{ fontSize: 16, color: '#64748B', marginBottom: 20 }}>
                  Current Quantity Limit: <Text style={{ fontWeight: '700', color: '#0F172A' }}>{selectedPromo.quantityLimit}</Text>
                </Text>

                {/* WARNING */}
                <View style={{
                  backgroundColor: '#FEE2E2',
                  borderRadius: 12,
                  padding: 16,
                  marginBottom: 24,
                  borderLeftWidth: 4,
                  borderLeftColor: '#EF4444'
                }}>
                  <Text style={{ color: '#B91C1C', fontWeight: '600', fontSize: 15 }}>
                    ⚠️ This action cannot be undone
                  </Text>
                  <Text style={{ color: '#B91C1C', marginTop: 4, lineHeight: 20 }}>
                    Once you reduce the quantity limit, you cannot increase it again.
                  </Text>
                </View>

                <Text style={promotionsStyles.label}>New Quantity Limit (must be lower)</Text>
                <TextInput
                  style={promotionsStyles.input}
                  keyboardType="numeric"
                  value={newQuantityLimit.toString()}
                  onChangeText={(text) => setNewQuantityLimit(Number(text) || 0)}
                  placeholder={`Less than ${selectedPromo.quantityLimit}`}
                />

                <TouchableOpacity 
                  style={[promotionsStyles.actionButton, { marginTop: 24 }]} 
                  onPress={handleUpdateQuantity}
                  disabled={actionLoading}
                >
                  <Text style={promotionsStyles.actionButtonText}>
                    {actionLoading ? "Reducing..." : "Confirm Reduction"}
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity 
                  style={{ marginTop: 16, alignItems: 'center' }}
                  onPress={() => setShowEditModal(false)}
                >
                  <Text style={{ color: '#64748B' }}>Cancel</Text>
                </TouchableOpacity>
              </>
            )}
          </View>
        </View>
      </Modal>

      {/* Payment Modal */}
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
          />
        </View>
      </Modal>
    </ScrollView>
  );
}