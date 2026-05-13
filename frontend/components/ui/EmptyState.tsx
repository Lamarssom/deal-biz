import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Feather } from '@expo/vector-icons';

interface EmptyStateProps {
  icon?: keyof typeof Feather.glyphMap;
  title: string;
  subtitle?: string;
}

export const EmptyState = ({ icon = 'heart', title, subtitle }: EmptyStateProps) => {
  return (
    <View style={styles.container}>
      <Feather name={icon} size={64} color="#CBD5E1" />
      <Text style={styles.title}>{title}</Text>
      {subtitle && <Text style={styles.subtitle}>{subtitle}</Text>}
    </View>
  );
};

const styles = StyleSheet.create({
  container: { alignItems: 'center', padding: 60, justifyContent: 'center' },
  title: { fontSize: 20, fontWeight: '600', color: '#0F172A', marginTop: 20 },
  subtitle: { fontSize: 15, color: '#64748B', textAlign: 'center', marginTop: 8, maxWidth: 240 },
});