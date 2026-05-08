import { StyleSheet } from 'react-native';

export const redemptionStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#E6ECF5',
  },
  content: {
    paddingTop: 20,            
    paddingHorizontal: 20,
  },
  header: {
    fontSize: 28,
    fontWeight: '700',
    color: '#0F172A',
    marginBottom: 8,
  },
  subHeader: {
    color: '#64748B',
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#0F172A',
    marginBottom: 12,
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 20,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.08,
    shadowRadius: 10,
    elevation: 4,
  },
  historyCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    opacity: 0.85,
  },
  qrContainer: {
    alignItems: 'center',
    marginVertical: 20,
  },
  instructionText: {
    textAlign: 'center',
    color: '#1C8EDA',
    fontWeight: '700',
    fontSize: 16,
  },
  expiryText: {
    textAlign: 'center',
    fontSize: 13,
    color: '#64748B',
    marginTop: 8,
  },
});