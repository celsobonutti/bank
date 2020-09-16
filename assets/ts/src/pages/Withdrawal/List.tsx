import React from 'react';
import { LoadingSpinner } from '../../components/elements/LoadingSpinner';
import { TransactionCard } from '../../components/elements/TransactionCard';
import { useWithdrawals } from '../../hooks/useWithdrawals';
import { Withdrawal } from '../../types/transactions';

export const List = () => {
  const { isLoading, data } = useWithdrawals();

  return (
    <>
      <h1>Histórico de saques</h1>
      {isLoading ? (
        <LoadingSpinner />
      ) : (
        (data as Withdrawal[]).map((withdrawal) => (
          <TransactionCard
            type="withdrawal"
            data={withdrawal}
            key={withdrawal.id}
          />
        ))
      )}
    </>
  );
};
