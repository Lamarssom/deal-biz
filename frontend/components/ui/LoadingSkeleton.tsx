import React from 'react';
import { View, Animated, Easing, StyleSheet } from 'react-native';

const Shimmer = ({ width = '100%', height = 20, borderRadius = 8 }: any) => {
  const animatedValue = React.useRef(new Animated.Value(0)).current;

  React.useEffect(() => {
    const shimmerAnimation = Animated.loop(
      Animated.timing(animatedValue, {
        toValue: 1,
        duration: 1200,
        easing: Easing.inOut(Easing.ease),
        useNativeDriver: true,
      })
    );
    shimmerAnimation.start();
    return () => shimmerAnimation.stop();
  }, []);

  const translateX = animatedValue.interpolate({
    inputRange: [0, 1],
    outputRange: [-300, 300],
  });

  return (
    <View style={[styles.shimmerContainer, { width, height, borderRadius }]}>
      <Animated.View
        style={[
          styles.shimmer,
          {
            transform: [{ translateX }],
          },
        ]}
      />
    </View>
  );
};

export const LoadingSkeleton = () => {
  return (
    <View style={styles.container}>
      {/* Promotion Card Skeleton */}
      <View style={styles.card}>
        <Shimmer height={160} borderRadius={16} />
        <View style={{ padding: 16, gap: 8 }}>
          <Shimmer width="70%" height={22} />
          <Shimmer width="40%" height={16} />
          <View style={{ flexDirection: 'row', gap: 12, marginTop: 8 }}>
            <Shimmer width="30%" height={24} />
            <Shimmer width="40%" height={24} />
          </View>
        </View>
      </View>

      {/* Multiple small cards */}
      {[1, 2].map((i) => (
        <View key={i} style={[styles.card, { padding: 16, flexDirection: 'row', gap: 12 }]}>
          <Shimmer width={60} height={60} borderRadius={12} />
          <View style={{ flex: 1, gap: 8 }}>
            <Shimmer width="85%" height={18} />
            <Shimmer width="55%" height={14} />
          </View>
        </View>
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: { gap: 20 },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    shadowColor: '#000',
    shadowOpacity: 0.05,
    shadowRadius: 8,
    elevation: 3,
    overflow: 'hidden',
  },
  shimmerContainer: {
    backgroundColor: '#E2E8F0',
    overflow: 'hidden',
  },
  shimmer: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(255,255,255,0.6)',
    opacity: 0.4,
  },
});