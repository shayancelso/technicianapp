import { createContext, ReactNode, useContext, useMemo, useState } from 'react';
import { ConnectivityState } from '@/constants/enums';

interface ConnectivityValue {
  state: ConnectivityState;
  isOnline: boolean;
  toggle: () => void;
}

const ConnectivityContext = createContext<ConnectivityValue>({
  state: 'online',
  isOnline: true,
  toggle: () => {},
});

export function ConnectivityProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<ConnectivityState>('online');

  const value = useMemo<ConnectivityValue>(
    () => ({
      state,
      isOnline: state === 'online',
      toggle: () => setState((s) => (s === 'online' ? 'forcedOffline' : 'online')),
    }),
    [state],
  );

  return <ConnectivityContext.Provider value={value}>{children}</ConnectivityContext.Provider>;
}

export const useConnectivity = () => useContext(ConnectivityContext);
