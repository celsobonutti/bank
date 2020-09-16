import { useQuery } from 'react-query';

import { protectedFetch } from '../utils/protectedFetch';
import { Withdrawal } from '../types/transactions';

const getWithdrawals = async () => {
  const withdrawals = await protectedFetch<Withdrawal[]>('/api/v1/withdrawals');
  return withdrawals;
};

export const useWithdrawals = () => {
  return useQuery('withdrawals', getWithdrawals);
};
