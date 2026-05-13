import React, { useState, useEffect } from 'react';
import { ScrollView, View, Text, TextInput, TouchableOpacity, FlatList } from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { SafeAreaView } from 'react-native-safe-area-context';

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

const SEARCH_HISTORY_KEY = '@deal_biz_search_history';

export default function SearchScreen() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');
  const [searchHistory, setSearchHistory] = useState<string[]>([]);
  const [selectedCategory, setSelectedCategory] = useState('all');

  useEffect(() => {
    loadSearchHistory();
  }, []);

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

  const handleSearch = () => {
    if (searchQuery.trim()) {
      saveToHistory(searchQuery);
      router.push({ pathname: '/home', params: { search: searchQuery, category: selectedCategory } });
    }
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#F8FAFC' }}>
      <ScrollView style={{ flex: 1 }}>
        {/* Search Bar */}
        <View style={{ padding: 20, backgroundColor: '#FFFFFF', borderBottomWidth: 1, borderBottomColor: '#E2E8F0' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: '#F1F5F9', borderRadius: 999, paddingHorizontal: 16 }}>
            <Feather name="search" size={20} color="#64748B" />
            <TextInput
              style={{ flex: 1, paddingVertical: 12, marginLeft: 8, fontSize: 16 }}
              placeholder="Search promotions or merchants..."
              value={searchQuery}
              onChangeText={setSearchQuery}
              onSubmitEditing={handleSearch}
              returnKeyType="search"
            />
          </View>
        </View>

        {/* Explore Categories - now richer */}
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
        {searchHistory.length > 0 && (
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
                onPress={() => {
                  setSearchQuery(item);
                  handleSearch();
                }}
              >
                <Text style={{ fontSize: 16 }}>{item}</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}