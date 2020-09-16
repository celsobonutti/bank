import { useQuery } from 'react-query';

import { protectedFetch } from '../utils/protectedFetch';
import { Withdrawal } from '../types/transactions';

const getWithdrawals = async () => {
  const withdrawals = await protectedFetch<Withdrawal[]>('/v1/api/withdrawals');
  return withdrawals;
};

export const useWithdrawals = () => {
  return useQuery('withdrawals', getWithdrawals);
};
