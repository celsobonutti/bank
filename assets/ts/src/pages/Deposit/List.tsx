import React from 'react';
import { LoadingSpinner } from '../../components/elements/LoadingSpinner';
import { TransactionCard } from '../../components/elements/TransactionCard';
import { useDeposits } from '../../hooks/useDeposits';
import { Deposit } from '../../types/transactions';

export const List = () => {
  const { isLoading, data } = useDeposits();

  return (
    <>
      <h1>Histórico de depósitos</h1>
      {isLoading ? (
        <LoadingSpinner />
      ) : (
        (data as Deposit[]).map((deposit) => (
          <TransactionCard type="deposit" data={deposit} key={deposit.id} />
        ))
      )}
    </>
  );
};
