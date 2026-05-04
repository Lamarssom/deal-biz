// styles/welcome.styles.ts
import { StyleSheet } from 'react-native';

export const welcomeStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  centerContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
  },
  checkContainer: {
    marginTop: 40,
  },
  checkCircle: {
    height: 118,
    width: 118,
    borderRadius: 999,
    backgroundColor: '#1C8EDA',
    alignItems: 'center',
    justifyContent: 'center',
  },
  bottomContent: {
    paddingBottom: 60,
    paddingHorizontal: 24,
    alignItems: 'center',
  },
  welcomeText: {
    fontSize: 42,
    fontWeight: '700',
    color: '#0F172A',
    textAlign: 'center',
    marginBottom: 12,
  },
  subtitle: {
    fontSize: 17,
    color: '#64748B',
    textAlign: 'center',
    lineHeight: 26,
    maxWidth: 300,
  },
  button: {
    marginTop: 48,
    width: '100%',
    maxWidth: 340,
    backgroundColor: '#1C8EDA',
    paddingVertical: 18,
    borderRadius: 999,
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: '600',
  },
});