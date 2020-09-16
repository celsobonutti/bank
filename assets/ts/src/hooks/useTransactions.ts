import { useQuery } from 'react-query';

import { protectedFetch } from '../utils/protectedFetch';

const getTransactions = async () => {
  const transactions = await protectedFetch<any[]>(
    '/api/v1/users/transactions'
  );
  return transactions;
};

export const useTransactions = () => {
  return useQuery('transactions', getTransactions);
};
