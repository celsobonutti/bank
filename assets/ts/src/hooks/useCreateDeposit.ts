import { useMutation, queryCache } from 'react-query';
import { protectedFetch } from '../utils/protectedFetch';

const createDeposit = async (quantity: number) => {
  const deposit = await protectedFetch('/api/v1/deposits', {
    body: JSON.stringify({ quantity }),
    method: 'POST'
  });
  return deposit;
};

type Params = {
  onError: (arg: any) => void;
  onSuccess: () => void;
};

export const useCreateDeposit = ({ onError, onSuccess }: Params) => {
  return useMutation(createDeposit, {
    onSuccess: () => {
      queryCache.invalidateQueries('user');
      queryCache.invalidateQueries('deposits');
      onSuccess();
    },
    onError: (error) => {
      onError(error);
    }
  });
};
