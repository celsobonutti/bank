import { useQuery } from 'react-query';
import { User } from '../types/user';

import { protectedFetch } from '../utils/protectedFetch';

const getProfile = async () => {
  const profile = await protectedFetch<User>('/api/v1/users');
  return profile;
};

export const useProfileQuery = () => {
  return useQuery('user', getProfile);
};
