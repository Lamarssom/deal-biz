import React, { createContext, useContext, useState, useEffect, ReactNode, useCallback, useRef } from 'react';
import { apiService } from '../services/api';
import { useAuth } from './AuthContext';
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
  const { isSignedIn } = useAuth();
  const [favourites, setFavourites] = useState<Favourite[]>([]);
  const [loading, setLoading] = useState(false);

  // FIXED: Accept both number (web) and NodeJS.Timeout (native)
  const pollInterval = useRef<NodeJS.Timeout | number | null>(null);

  const refreshFavourites = useCallback(async () => {
    if (!isSignedIn) {
      setFavourites([]);
      return;
    }
    setLoading(true);
    try {
      const data = await apiService.getMyFavourites();
      setFavourites(data);
    } catch (err) {
      console.error('Failed to load favourites:', err);
    } finally {
      setLoading(false);
    }
  }, [isSignedIn]);

  // Initial load + login changes
  useEffect(() => {
    if (isSignedIn) {
      refreshFavourites();
    } else {
      setFavourites([]);
    }
  }, [isSignedIn, refreshFavourites]);

  // Real-time improvements
  useEffect(() => {
    if (!isSignedIn) return;

    // Mobile: AppState change
    const appStateSub = AppState.addEventListener('change', (nextAppState) => {
      if (nextAppState === 'active') refreshFavourites();
    });

    // Web + Mobile: Tab becomes visible / window focus
    const handleVisibilityChange = () => {
      if (document.visibilityState === 'visible') {
        refreshFavourites();
      }
    };

    if (Platform.OS === 'web') {
      document.addEventListener('visibilitychange', handleVisibilityChange);
      window.addEventListener('focus', refreshFavourites);
    }

    // Light polling (every 10 seconds)
    pollInterval.current = setInterval(() => {
      if (Platform.OS === 'web' && document.visibilityState === 'visible') {
        refreshFavourites();
      }
    }, 10000);

    return () => {
      appStateSub.remove();
      if (Platform.OS === 'web') {
        document.removeEventListener('visibilitychange', handleVisibilityChange);
        window.removeEventListener('focus', refreshFavourites);
      }
      if (pollInterval.current) {
        clearInterval(pollInterval.current);
      }
    };
  }, [isSignedIn, refreshFavourites]);

  const isFavourite = (promotionId: string) => {
    return favourites.some(f => f.promotionId === promotionId);
  };

  const toggleFavourite = async (promotionId: string) => {
    const alreadyFavourite = isFavourite(promotionId);

    // Optimistic update
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