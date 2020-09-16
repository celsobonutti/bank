import React from 'react';
import { LoadingSpinner } from '../components/elements/LoadingSpinner';
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
    return <LoadingSpinner />;
  }

  if (isError) {
    return (
      <p>
        Oops, parece que nós encontramos um erro grave. Entre em contato com
        nossa equipe para que possamos avaliar.
      </p>
    );
  }

  return (
    <ProfileContext.Provider value={data}>{children}</ProfileContext.Provider>
  );
};
