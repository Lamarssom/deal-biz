import React, { Component, ReactNode } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Platform } from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import Toast from 'react-native-toast-message';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error) {
    console.error('Global Error Caught:', error);
    Toast.show({
      type: 'error',
      text1: 'Something went wrong',
      text2: 'The app encountered an unexpected error.',
    });
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback onRetry={() => this.setState({ hasError: false })} />;
    }
    return this.props.children;
  }
}

function ErrorFallback({ onRetry }: { onRetry: () => void }) {
  const router = useRouter();

  const handleRetry = () => {
    onRetry();
    if (Platform.OS === 'web') {
      window.location.reload();
    } else {
      router.replace('/(tabs)/home');
    }
  };

  return (
    <View style={styles.container}>
      <Feather name="alert-triangle" size={64} color="#EF4444" />
      <Text style={styles.title}>Oops! Something went wrong</Text>
      <Text style={styles.subtitle}>
        We encountered an unexpected error. Don't worry, it's not your fault.
      </Text>

      <TouchableOpacity style={styles.retryButton} onPress={handleRetry}>
        <Feather name="refresh-cw" size={20} color="#FFFFFF" />
        <Text style={styles.retryText}>Try Again</Text>
      </TouchableOpacity>

      <TouchableOpacity 
        style={styles.homeButton} 
        onPress={() => router.replace('/(tabs)/home')}
      >
        <Text style={styles.homeText}>Go to Home</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
    backgroundColor: '#F8FAFC',
  },
  title: { fontSize: 24, fontWeight: '700', color: '#0F172A', marginTop: 20, textAlign: 'center' },
  subtitle: { fontSize: 16, color: '#64748B', textAlign: 'center', marginTop: 12, maxWidth: 280 },
  retryButton: {
    flexDirection: 'row',
    backgroundColor: '#1C8EDA',
    paddingHorizontal: 32,
    paddingVertical: 14,
    borderRadius: 999,
    marginTop: 40,
    alignItems: 'center',
    gap: 10,
  },
  retryText: { color: '#FFFFFF', fontWeight: '600', fontSize: 16 },
  homeButton: { marginTop: 20, padding: 12 },
  homeText: { color: '#1C8EDA', fontWeight: '600' },
});