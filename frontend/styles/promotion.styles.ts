import { StyleSheet } from 'react-native';

export const promotionStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  header: {
    paddingHorizontal: 24,
    paddingTop: 60,
    paddingBottom: 20,
  },
  title: {
    fontSize: 26,
    fontWeight: '700',
    color: '#0F172A',
    lineHeight: 32,
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 24,
    padding: 24,
    marginHorizontal: 24,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.08,
    shadowRadius: 10,
    elevation: 4,
  },
  priceContainer: {
    flexDirection: 'row',
    alignItems: 'baseline',
    marginVertical: 16,
  },
  currentPrice: {
    fontSize: 32,
    fontWeight: '700',
    color: '#1C8EDA',
  },
  originalPrice: {
    fontSize: 18,
    textDecorationLine: 'line-through',
    color: '#94A3B8',
    marginLeft: 12,
  },
  merchantName: {
    fontSize: 17,
    fontWeight: '600',
    color: '#0F172A',
  },
  metaText: {
    color: '#64748B',
    fontSize: 15,
    marginTop: 4,
  },
  description: {
    fontSize: 16,
    lineHeight: 24,
    color: '#334155',
    marginTop: 16,
  },
  button: {
    backgroundColor: '#1C8EDA',
    paddingVertical: 18,
    borderRadius: 999,
    alignItems: 'center',
    marginTop: 32,
  },
  buttonText: {
    color: 'white',
    fontSize: 17,
    fontWeight: '600',
  },
  backButton: {
    padding: 14,
    alignSelf: 'center',
    marginTop: 20,
  },
});