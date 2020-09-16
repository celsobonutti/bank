import { useMutation, queryCache } from 'react-query';
import { protectedFetch } from '../utils/protectedFetch';

const createWithdrawal = async (quantity: number) => {
  const withdrawal = await protectedFetch('/v1/api/withdrawals', {
    body: JSON.stringify({ quantity }),
    method: 'POST'
  });
  return withdrawal;
};

type Params = {
  onError: () => void;
  onSuccess: () => void;
};

export const useCreateWithdrawal = ({ onError, onSuccess }: Params) => {
  return useMutation(createWithdrawal, {
    onSuccess: () => {
      queryCache.invalidateQueries('user');
      queryCache.invalidateQueries('withdrawals');
      onSuccess();
    },
    onError: () => {
      onError();
    }
  });
};
