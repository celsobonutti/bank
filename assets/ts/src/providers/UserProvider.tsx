import React from 'react';
import { useProfileQuery } from '../hooks/useProfile';
import { User } from '../types/user';

const ProfileContext = React.createContext<User | undefined>(undefined);

type ProviderProps = {
  children: React.ReactNode;
};

export const useProfile = () => React.useContext(ProfileContext) as User;

export const UserProvider = ({ children }: ProviderProps) => {
  const { isLoading, isError, data } = useProfileQuery();

  if (isLoading) {
    return <span>Loading...</span>;
  }

  if (isError) {
    return <span>Error</span>;
  }

  return (
    <ProfileContext.Provider value={data}>{children}</ProfileContext.Provider>
  );
};
