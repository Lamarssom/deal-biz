import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { Feather } from '@expo/vector-icons';

interface ErrorStateProps {
  message?: string;
  onRetry?: () => void;
}

export const ErrorState = ({ message = "Something went wrong", onRetry }: ErrorStateProps) => {
  return (
    <View style={styles.container}>
      <Feather name="alert-circle" size={64} color="#EF4444" />
      <Text style={styles.title}>Oops!</Text>
      <Text style={styles.message}>{message}</Text>
      
      {onRetry && (
        <TouchableOpacity style={styles.retryButton} onPress={onRetry}>
          <Feather name="refresh-cw" size={18} color="#FFFFFF" />
          <Text style={styles.retryText}>Try Again</Text>
        </TouchableOpacity>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: { alignItems: 'center', padding: 40, justifyContent: 'center' },
  title: { fontSize: 22, fontWeight: '700', color: '#0F172A', marginTop: 16 },
  message: { fontSize: 16, color: '#64748B', textAlign: 'center', marginTop: 8, maxWidth: 260 },
  retryButton: {
    flexDirection: 'row',
    backgroundColor: '#1C8EDA',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 999,
    marginTop: 24,
    alignItems: 'center',
    gap: 8,
  },
  retryText: { color: '#FFFFFF', fontWeight: '600' },
});