import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { apiService } from '../services/api';
import { useAuth } from './AuthContext';

interface MerchantAnalytics {
  outstandingBalance: number;
  totalPromotions: number;
  totalRedemptions: number;
  activePromotions: number;
  creditLimit: number;
}

interface MerchantContextType {
  analytics: MerchantAnalytics | null;
  loading: boolean;
  refreshAnalytics: () => Promise<void>;
}

const MerchantContext = createContext<MerchantContextType | undefined>(undefined);

export function MerchantProvider({ children }: { children: ReactNode }) {
  const { isSignedIn, user } = useAuth();
  const [analytics, setAnalytics] = useState<MerchantAnalytics | null>(null);
  const [loading, setLoading] = useState(false);

  const refreshAnalytics = async () => {
    if (!isSignedIn || user?.role !== 'MERCHANT') return;

    setLoading(true);
    try {
      const data = await apiService.getMerchantAnalytics();
      const parsedBalance = typeof data?.outstandingBalance === 'string'
        ? parseFloat(data.outstandingBalance)
        : typeof data?.outstandingBalance === 'number'
        ? data.outstandingBalance
        : 0;

      setAnalytics({
        outstandingBalance: parsedBalance,
        totalPromotions: data?.totalPromotions || 0,
        totalRedemptions: data?.totalRedemptions || 0,
        activePromotions: data?.activePromotions || 0,
        creditLimit: data?.creditLimit || 5000,
      });
    } catch (err) {
      console.error('Failed to refresh merchant analytics:', err);
    } finally {
      setLoading(false);
    }
  };

  // Auto-load when merchant logs in
  useEffect(() => {
    if (isSignedIn && user?.role === 'MERCHANT') {
      refreshAnalytics();
    } else {
      setAnalytics(null);
    }
  }, [isSignedIn, user]);

  return (
    <MerchantContext.Provider value={{ analytics, loading, refreshAnalytics }}>
      {children}
    </MerchantContext.Provider>
  );
}

export const useMerchant = () => {
  const context = useContext(MerchantContext);
  if (!context) {
    throw new Error('useMerchant must be used within MerchantProvider');
  }
  return context;
};