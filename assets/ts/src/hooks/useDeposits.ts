import { useQuery } from 'react-query';

import { protectedFetch } from '../utils/protectedFetch';
import { Deposit } from '../types/transactions';

const getDeposits = async () => {
  const deposits = await protectedFetch<Deposit[]>('/api/v1/deposits');
  return deposits;
};

export const useDeposits = () => {
  return useQuery('deposits', getDeposits);
};
