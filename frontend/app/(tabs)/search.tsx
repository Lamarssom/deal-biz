import React, { useState, useEffect, useCallback } from 'react';
import { 
  ScrollView, 
  View, 
  Text, 
  TextInput, 
  TouchableOpacity, 
  FlatList,
  ActivityIndicator,
  Image,
  Platform
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { SafeAreaView } from 'react-native-safe-area-context';

import { useAuth } from '../../context/AuthContext';
import { useFavourites } from '../../context/FavouritesContext';
import { apiService } from '../../services/api';
import { LoadingSkeleton } from '../../components/ui/LoadingSkeleton';
import { EmptyState } from '../../components/ui/EmptyState';

const CATEGORIES = [
  { id: 'all', label: 'All', icon: 'grid' },
  { id: 'food', label: 'Food & Drink', icon: 'coffee' },
  { id: 'fashion', label: 'Fashion', icon: 'shopping-bag' },
  { id: 'grocery', label: 'Groceries', icon: 'shopping-cart' },
  { id: 'health', label: 'Health & Beauty', icon: 'heart' },
  { id: 'electronics', label: 'Electronics', icon: 'monitor' },
  { id: 'pharmacy', label: 'Pharmacy', icon: 'plus-circle' },
  { id: 'services', label: 'Services', icon: 'tool' },
  { id: 'supermarket', label: 'Supermarket', icon: 'shopping-bag' },
];

// Mapping frontend category → actual merchant.businessCategory (from signup)
const CATEGORY_MAPPING: { [key: string]: string[] } = {
  food: ['Restaurant & Food', 'Food & Drink'],
  fashion: ['Fashion & Clothing'],
  grocery: ['Supermarket & Groceries', 'Groceries'],
  health: ['Pharmacy & Health', 'Beauty & Salon', 'Health'],
  electronics: ['Electronics'],
  pharmacy: ['Pharmacy & Health'],
  services: ['Services'],
  supermarket: ['Supermarket & Groceries'],
};

const SEARCH_HISTORY_KEY = '@deal_biz_search_history';

export default function SearchScreen() {
  const router = useRouter();
  const { user, isSignedIn } = useAuth();
  const { isFavourite, toggleFavourite } = useFavourites();

  const [searchQuery, setSearchQuery] = useState('');
  const [searchHistory, setSearchHistory] = useState<string[]>([]);
  const [selectedCategory, setSelectedCategory] = useState('all');

  const [promotions, setPromotions] = useState<any[]>([]);
  const [filteredResults, setFilteredResults] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  const estimateDriveTime = (distanceKm: number) => {
    const minutes = Math.round(distanceKm * 3.5);
    if (minutes < 10) return '< 10 min';
    if (minutes > 45) return '> 45 min';
    return `${Math.max(10, Math.round(minutes / 5) * 5)}-${Math.round(minutes / 5) * 5 + 5} min`;
  };

  const getPercentageOff = (promo: any) => {
    if (!promo.originalPrice || !promo.price) return 0;
    return Math.round(((promo.originalPrice - promo.price) / promo.originalPrice) * 100);
  };

  const isActivePromotion = (promo: any) => {
    const expired = new Date(promo.expiry) < new Date();
    const exhausted = promo.quantityLimit && (promo.redeemedCount || 0) >= promo.quantityLimit;
    return !expired && !exhausted;
  };

  const loadPromotions = async () => {
    setLoading(true);
    try {
      const data = await apiService.getNearbyPromotions(6.5244, 3.3792, 50);
      setPromotions(data);
    } catch (error) {
      console.error('Failed to load promotions');
    } finally {
      setLoading(false);
    }
  };

  const loadSearchHistory = async () => {
    const history = await AsyncStorage.getItem(SEARCH_HISTORY_KEY);
    if (history) setSearchHistory(JSON.parse(history));
  };

  const saveToHistory = async (query: string) => {
    if (!query.trim()) return;
    const newHistory = [query, ...searchHistory.filter(h => h !== query)].slice(0, 10);
    setSearchHistory(newHistory);
    await AsyncStorage.setItem(SEARCH_HISTORY_KEY, JSON.stringify(newHistory));
  };

  const clearHistory = async () => {
    setSearchHistory([]);
    await AsyncStorage.removeItem(SEARCH_HISTORY_KEY);
  };

  // Real-time filtering (search + category)
  useEffect(() => {
    if (!promotions.length) return;

    let results = promotions.filter(isActivePromotion);

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase().trim();
      results = results.filter((promo: any) =>
        promo.title?.toLowerCase().includes(q) ||
        promo.merchant?.businessName?.toLowerCase().includes(q) ||
        promo.description?.toLowerCase().includes(q)
      );
    }

    if (selectedCategory !== 'all') {
      const allowedCategories = CATEGORY_MAPPING[selectedCategory] || [];
      results = results.filter((promo: any) => {
        const merchantCategory = promo.merchant?.category || promo.category || '';
        return allowedCategories.some((cat: string) =>
          merchantCategory.toLowerCase().includes(cat.toLowerCase())
        );
      });
    }

    setFilteredResults(results);
  }, [searchQuery, selectedCategory, promotions]);

  useFocusEffect(
    useCallback(() => {
      if (isSignedIn) {
        loadPromotions();
        loadSearchHistory();
      }
    }, [isSignedIn])
  );

  const handleSearchSubmit = () => {
    if (searchQuery.trim()) saveToHistory(searchQuery);
  };

  const handlePromotionPress = (id: string) => {
    router.push({ pathname: '/promotions/[id]', params: { id } });
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#F8FAFC' }}>
      <ScrollView style={{ flex: 1 }} showsVerticalScrollIndicator={false}>
        {/* Search Bar */}
        <View style={{ padding: 20, backgroundColor: '#FFFFFF', borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: '#F1F5F9', borderRadius: 999, paddingHorizontal: 16 }}>
            <Feather name="search" size={20} color="#64748B" />
            <TextInput
              style={{ flex: 1, paddingVertical: 12, marginLeft: 8, fontSize: 16 }}
              placeholder="Search promotions or merchants..."
              value={searchQuery}
              onChangeText={setSearchQuery}
              onSubmitEditing={handleSearchSubmit}
              returnKeyType="search"
            />
          </View>
        </View>

        {/* Explore Categories */}
        <View style={{ padding: 20 }}>
          <Text style={{ fontSize: 18, fontWeight: '700', marginBottom: 12 }}>Explore Categories</Text>
          <FlatList
            horizontal
            data={CATEGORIES}
            showsHorizontalScrollIndicator={false}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => (
              <TouchableOpacity
                onPress={() => setSelectedCategory(item.id)}
                style={{
                  paddingHorizontal: 20,
                  paddingVertical: 10,
                  backgroundColor: selectedCategory === item.id ? '#1C8EDA' : '#F1F5F9',
                  borderRadius: 999,
                  marginRight: 8,
                  flexDirection: 'row',
                  alignItems: 'center',
                  gap: 6,
                }}
              >
                <Feather name={item.icon as any} size={18} color={selectedCategory === item.id ? '#fff' : '#64748B'} />
                <Text style={{ color: selectedCategory === item.id ? '#fff' : '#334155', fontWeight: '600' }}>
                  {item.label}
                </Text>
              </TouchableOpacity>
            )}
          />
        </View>

        {/* Recent Searches */}
        {searchHistory.length > 0 && !searchQuery && (
          <View style={{ padding: 20 }}>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
              <Text style={{ fontSize: 18, fontWeight: '700' }}>Recent Searches</Text>
              <TouchableOpacity onPress={clearHistory}>
                <Text style={{ color: '#EF4444', fontSize: 14 }}>Clear</Text>
              </TouchableOpacity>
            </View>
            {searchHistory.map((item, index) => (
              <TouchableOpacity
                key={index}
                style={{ paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}
                onPress={() => setSearchQuery(item)}
              >
                <Text style={{ fontSize: 16 }}>{item}</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}

        {/* Live Search + Category Results */}
        {(searchQuery || selectedCategory !== 'all') && (
          <View style={{ padding: 20 }}>
            <Text style={{ fontSize: 18, fontWeight: '700', marginBottom: 12 }}>
              {searchQuery ? `Results for "${searchQuery}"` : `${CATEGORIES.find(c => c.id === selectedCategory)?.label || 'Filtered'} Promotions`}
            </Text>

            {loading ? (
              <LoadingSkeleton />
            ) : filteredResults.length === 0 ? (
              <EmptyState 
                icon="search" 
                title="No matching promotions" 
                subtitle="Try a different keyword or category" 
              />
            ) : (
              <FlatList
                data={filteredResults}
                keyExtractor={(item) => item.id}
                scrollEnabled={false}
                renderItem={({ item: promo }) => {
                  const perc = getPercentageOff(promo);
                  const favourited = isFavourite(promo.id);
                  return (
                    <TouchableOpacity
                      key={promo.id}
                      onPress={() => handlePromotionPress(promo.id)}
                      style={{
                        backgroundColor: '#fff',
                        borderRadius: 16,
                        marginBottom: 16,
                        overflow: 'hidden',
                        shadowColor: '#000',
                        shadowOffset: { width: 0, height: 3 },
                        shadowOpacity: 0.08,
                        shadowRadius: 8,
                        elevation: 4,
                      }}
                    >
                      <View style={{ position: 'relative' }}>
                        {promo.photoUrl ? (
                          <Image source={{ uri: promo.photoUrl }} style={{ width: '100%', height: 140 }} resizeMode="cover" />
                        ) : (
                          <View style={{ height: 140, backgroundColor: '#E2E8F0', justifyContent: 'center', alignItems: 'center' }}>
                            <Text>No image</Text>
                          </View>
                        )}
                        {perc > 0 && (
                          <View style={{
                            position: 'absolute',
                            top: 12,
                            left: 12,
                            backgroundColor: '#1C8EDA',
                            paddingHorizontal: 12,
                            paddingVertical: 4,
                            borderRadius: 4,
                            transform: [{ rotate: '-10deg' }],
                          }}>
                            <Text style={{ color: '#fff', fontWeight: '700' }}>{perc}% OFF</Text>
                          </View>
                        )}
                      </View>

                      <View style={{ padding: 14 }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                          <Text style={{ fontSize: 17, fontWeight: '600', flex: 1 }}>
                            {promo.merchant?.businessName}
                          </Text>
                          <TouchableOpacity onPress={(e) => { e.stopPropagation(); toggleFavourite(promo.id); }}>
                            <Text style={{ fontSize: 24 }}>{favourited ? '❤️' : '♡'}</Text>
                          </TouchableOpacity>
                        </View>

                        <Text style={{ color: '#1C8EDA', fontWeight: '700', fontSize: 18, marginTop: 4 }}>
                          ₦{promo.price}
                        </Text>

                        <Text style={{ color: '#64748B', marginTop: 4 }}>
                          {promo.distanceKm} km • {estimateDriveTime(promo.distanceKm)}
                        </Text>
                      </View>
                    </TouchableOpacity>
                  );
                }}
              />
            )}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}