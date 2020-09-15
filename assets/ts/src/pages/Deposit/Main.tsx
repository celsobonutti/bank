import React from 'react';
import { TransactionCard } from '../../components/elements/TransactionCard';
import { useDeposits } from '../../hooks/useDeposits';
import { Deposit } from '../../types/transactions';

export const Main = () => {
  const { isLoading, data } = useDeposits();

  return (
    <>
      <h1>Histórico de depósitos</h1>
      {isLoading ? (
        <p>Carregando...</p>
      ) : (
        (data as Deposit[]).map((deposit) => (
          <TransactionCard type="deposit" data={deposit} key={deposit.id} />
        ))
      )}
    </>
  );
};
