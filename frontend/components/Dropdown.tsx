import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  ScrollView,
  Modal,
  TextInput,
} from 'react-native';
import { Feather } from '@expo/vector-icons';

interface DropdownProps {
  label: string;
  options: Array<{ id: number; label: string; value: string }>;
  value: string;
  onSelect: (value: string) => void;
  placeholder: string;
  icon?: string;
  isLoading?: boolean;
}

export function Dropdown({
  label,
  options,
  value,
  onSelect,
  placeholder,
  icon = 'map-pin',
  isLoading = false,
}: DropdownProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [searchText, setSearchText] = useState('');

  const filteredOptions = options.filter((opt) =>
    opt.label.toLowerCase().includes(searchText.toLowerCase())
  );

  const selectedLabel = options.find((opt) => opt.value === value)?.label || value;

  return (
    <View>
      <Text style={{ fontSize: 14, fontWeight: '500', color: '#1E293B', marginBottom: 8 }}>
        {label}
      </Text>

      <TouchableOpacity
        onPress={() => !isLoading && setIsOpen(true)}
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          backgroundColor: '#F1F5F9',
          borderRadius: 8,
          paddingHorizontal: 12,
          paddingVertical: 12,
          borderWidth: 1,
          borderColor: '#E2E8F0',
          opacity: isLoading ? 0.6 : 1,
        }}
      >
        <Feather name={icon as any} size={20} color="#64748B" />
        <Text
          style={{
            flex: 1,
            marginLeft: 12,
            color: selectedLabel ? '#1E293B' : '#94A3B8',
            fontSize: 14,
          }}
        >
          {isLoading ? 'Loading...' : selectedLabel || placeholder}
        </Text>
        <Feather name="chevron-down" size={20} color="#64748B" />
      </TouchableOpacity>

      <Modal
        visible={isOpen}
        transparent
        animationType="slide"
        onRequestClose={() => setIsOpen(false)}
      >
        <View
          style={{
            flex: 1,
            backgroundColor: 'rgba(0,0,0,0.5)',
            justifyContent: 'flex-end',
          }}
        >
          <View
            style={{
              backgroundColor: '#FFFFFF',
              borderTopLeftRadius: 20,
              borderTopRightRadius: 20,
              maxHeight: '80%',
              paddingTop: 16,
            }}
          >
            {/* Header */}
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                alignItems: 'center',
                paddingHorizontal: 16,
                marginBottom: 16,
              }}
            >
              <Text style={{ fontSize: 18, fontWeight: '600', color: '#1E293B' }}>
                Select {label}
              </Text>
              <TouchableOpacity onPress={() => setIsOpen(false)}>
                <Feather name="x" size={24} color="#64748B" />
              </TouchableOpacity>
            </View>

            {/* Search Input */}
            <View
              style={{
                marginHorizontal: 16,
                marginBottom: 12,
              }}
            >
              <TextInput
                placeholder={`Search ${label}...`}
                value={searchText}
                onChangeText={setSearchText}
                style={{
                  backgroundColor: '#F1F5F9',
                  borderRadius: 8,
                  paddingHorizontal: 12,
                  paddingVertical: 10,
                  fontSize: 14,
                  color: '#1E293B',
                  borderWidth: 1,
                  borderColor: '#E2E8F0',
                }}
                placeholderTextColor="#94A3B8"
              />
            </View>

            {/* Options List */}
            <ScrollView
              style={{
                paddingHorizontal: 16,
                paddingBottom: 16,
              }}
            >
              {filteredOptions.length === 0 ? (
                <View style={{ alignItems: 'center', paddingVertical: 32 }}>
                  <Text style={{ color: '#94A3B8', fontSize: 14 }}>
                    No options found
                  </Text>
                </View>
              ) : (
                filteredOptions.map((option) => (
                  <TouchableOpacity
                    key={option.id}
                    onPress={() => {
                      onSelect(option.value);
                      setIsOpen(false);
                      setSearchText('');
                    }}
                    style={{
                      paddingVertical: 12,
                      paddingHorizontal: 12,
                      marginBottom: 8,
                      backgroundColor:
                        value === option.value ? '#E0E7FF' : '#F8FAFC',
                      borderRadius: 8,
                      borderWidth: 1,
                      borderColor:
                        value === option.value ? '#4F46E5' : '#E2E8F0',
                    }}
                  >
                    <Text
                      style={{
                        fontSize: 14,
                        color:
                          value === option.value ? '#4F46E5' : '#1E293B',
                        fontWeight:
                          value === option.value ? '600' : '400',
                      }}
                    >
                      {option.label}
                    </Text>
                  </TouchableOpacity>
                ))
              )}
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}
