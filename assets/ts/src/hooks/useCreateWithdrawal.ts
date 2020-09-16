import { useMutation, queryCache } from 'react-query';
import { protectedFetch } from '../utils/protectedFetch';

const createWithdrawal = async (quantity: number) => {
  const withdrawal = await protectedFetch('/api/v1/withdrawals', {
    body: JSON.stringify({ quantity }),
    method: 'POST'
  });
  return withdrawal;
};

type Params = {
  onError: (arg: any) => void;
  onSuccess: () => void;
};

export const useCreateWithdrawal = ({ onError, onSuccess }: Params) => {
  return useMutation(createWithdrawal, {
    onSuccess: () => {
      queryCache.invalidateQueries('user');
      queryCache.invalidateQueries('withdrawals');
      onSuccess();
    },
    onError: (error) => {
      onError(error);
    }
  });
};
