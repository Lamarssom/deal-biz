import React, { createContext, useContext, useState, useEffect, useCallback, useRef, ReactNode } from 'react';
import { apiService } from '../services/api';
import { useAuth } from './AuthContext';
import { usePathname } from 'expo-router';
import { AppState, Platform } from 'react-native';

interface Favourite {
  id: string;
  promotionId: string;
  promotion: any;
}

interface FavouritesContextType {
  favourites: Favourite[];
  loading: boolean;
  isFavourite: (promotionId: string) => boolean;
  toggleFavourite: (promotionId: string) => Promise<void>;
  refreshFavourites: () => Promise<void>;
}

const FavouritesContext = createContext<FavouritesContextType | undefined>(undefined);

export function FavouritesProvider({ children }: { children: ReactNode }) {
  const { isSignedIn, isLoading: authLoading } = useAuth();
  const pathname = usePathname();

  const [favourites, setFavourites] = useState<Favourite[]>([]);
  const [loading, setLoading] = useState(false);

  const pollInterval = useRef<NodeJS.Timeout | number | null>(null);
  const hasInitialized = useRef(false);

  const isProtectedRoute = pathname?.startsWith('/(tabs)') === true;

  const refreshFavourites = useCallback(async () => {
    if (!isSignedIn || authLoading || !isProtectedRoute) {
      //console.log(`[FavouritesProvider] Skipped (signedIn: ${isSignedIn}, authLoading: ${authLoading}, route: ${pathname})`);
      setFavourites([]);
      setLoading(false);
      return;
    }

    //console.log(`[FavouritesProvider] Refreshing favourites on protected route: ${pathname}`);
    setLoading(true);
    hasInitialized.current = true;

    try {
      const data = await apiService.getMyFavourites();
      setFavourites(data || []);
    } catch (err: any) {
      console.error('Failed to load favourites:', err);
      setFavourites([]);
    } finally {
      setLoading(false);
    }
  }, [isSignedIn, authLoading, isProtectedRoute, pathname]);

  // Initial load
  useEffect(() => {
    refreshFavourites();
  }, [refreshFavourites]);

  // Real-time listeners + polling (only on protected routes)
  useEffect(() => {
    if (!isSignedIn || authLoading || !isProtectedRoute) return;

    //console.log('[FavouritesProvider] 🚀 Starting listeners + polling');

    const appStateSub = AppState.addEventListener('change', (nextAppState) => {
      if (nextAppState === 'active') refreshFavourites();
    });

    const handleVisibilityChange = () => {
      if (document.visibilityState === 'visible') refreshFavourites();
    };

    if (Platform.OS === 'web') {
      document.addEventListener('visibilitychange', handleVisibilityChange);
      window.addEventListener('focus', refreshFavourites);
    }

    pollInterval.current = setInterval(() => {
      if (Platform.OS === 'web' && document.visibilityState === 'visible') {
        refreshFavourites();
      }
    }, 15000);

    return () => {
      appStateSub.remove();
      if (Platform.OS === 'web') {
        document.removeEventListener('visibilitychange', handleVisibilityChange);
        window.removeEventListener('focus', refreshFavourites);
      }
      if (pollInterval.current) {
        clearInterval(pollInterval.current);
        pollInterval.current = null;
      }
    };
  }, [isSignedIn, authLoading, isProtectedRoute, refreshFavourites]);

  const isFavourite = (promotionId: string) => favourites.some(f => f.promotionId === promotionId);

  const toggleFavourite = async (promotionId: string) => {
    if (!isSignedIn || authLoading || !isProtectedRoute) return;

    const alreadyFavourite = isFavourite(promotionId);

    if (alreadyFavourite) {
      setFavourites(prev => prev.filter(f => f.promotionId !== promotionId));
    } else {
      setFavourites(prev => [...prev, { id: '', promotionId, promotion: {} }]);
    }

    try {
      if (alreadyFavourite) {
        await apiService.removeFavourite(promotionId);
      } else {
        await apiService.addFavourite(promotionId);
      }
      await refreshFavourites();
    } catch (err) {
      console.error('Favourite toggle failed:', err);
      await refreshFavourites();
    }
  };

  return (
    <FavouritesContext.Provider value={{
      favourites,
      loading,
      isFavourite,
      toggleFavourite,
      refreshFavourites,
    }}>
      {children}
    </FavouritesContext.Provider>
  );
}

export const useFavourites = () => {
  const context = useContext(FavouritesContext);
  if (!context) throw new Error('useFavourites must be used within FavouritesProvider');
  return context;
};