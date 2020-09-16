import { useMutation, queryCache } from 'react-query';
import { protectedFetch } from '../utils/protectedFetch';

const createPayment = async (boleto_code: number) => {
  const payment = await protectedFetch('/v1/api/payments', {
    body: JSON.stringify({ boleto_code }),
    method: 'POST'
  });
  return payment;
};

type Params = {
  onError: () => void;
  onSuccess: () => void;
};

export const useCreatePayment = ({ onError, onSuccess }: Params) => {
  return useMutation(createPayment, {
    onSuccess: () => {
      queryCache.invalidateQueries('user');
      queryCache.invalidateQueries('payments');
      onSuccess();
    },
    onError: () => {
      onError();
    }
  });
};
