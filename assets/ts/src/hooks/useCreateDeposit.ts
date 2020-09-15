import { useMutation, queryCache } from 'react-query';
import { protectedFetch } from '../utils/protectedFetch';

const createDeposit = async (quantity: number) => {
  const profile = await protectedFetch('/v1/api/deposits', {
    body: JSON.stringify({ quantity }),
    method: 'POST'
  });
  return profile;
};

type Params = {
  onError: () => void;
  onSuccess: () => void;
};

export const useCreateDeposit = ({ onError, onSuccess }: Params) => {
  return useMutation(createDeposit, {
    onSuccess: () => {
      queryCache.invalidateQueries('user');
      queryCache.invalidateQueries('deposits');
      onSuccess();
    },
    onError: () => {
      onError();
    }
  });
};
