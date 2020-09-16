import { useQuery } from 'react-query';

import { protectedFetch } from '../utils/protectedFetch';
import { Payment } from '../types/transactions';

const getPayments = async () => {
  const payments = await protectedFetch<Payment[]>('/api/v1/payments');
  return payments;
};

export const usePayments = () => {
  return useQuery('payments', getPayments);
};
