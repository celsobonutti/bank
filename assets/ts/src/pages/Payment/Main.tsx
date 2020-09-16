import React from 'react';
import { TransactionCard } from '../../components/elements/TransactionCard';
import { usePayments } from '../../hooks/usePayments';
import { Payment } from '../../types/transactions';

export const Main = () => {
  const { isLoading, data } = usePayments();

  return (
    <>
      <h1>Histórico de pagamentos</h1>
      {isLoading ? (
        <p>Carregando...</p>
      ) : (
        (data as Payment[]).map((payment) => (
          <TransactionCard type="payment" data={payment} key={payment.id} />
        ))
      )}
    </>
  );
};
