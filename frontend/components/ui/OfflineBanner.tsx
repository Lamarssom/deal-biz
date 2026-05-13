import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Feather } from '@expo/vector-icons';
import { useNetwork } from '../../context/NetworkContext';

export const OfflineBanner = () => {
  const { isConnected, isInternetReachable } = useNetwork();

  if (isConnected && isInternetReachable) return null;

  return (
    <View style={styles.banner}>
      <Feather name="wifi-off" size={16} color="#FFFFFF" />
      <Text style={styles.text}>
        You're offline. Some features may be limited.
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  banner: {
    backgroundColor: '#F59E0B',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 10,
    gap: 8,
  },
  text: {
    color: '#FFFFFF',
    fontWeight: '600',
    fontSize: 14,
  },
});