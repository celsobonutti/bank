import React from 'react';
import { LoadingSpinner } from '../../components/elements/LoadingSpinner';
import { TransactionCard } from '../../components/elements/TransactionCard';

import { useTransactions } from '../../hooks/useTransactions';

export const Main = () => {
  const { isLoading, data } = useTransactions();

  if (isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <>
      <h1>Histórico de transações</h1>
      {data?.map((transaction) => (
        <TransactionCard
          type={transaction.type}
          data={transaction}
          key={`${transaction.type}::${transaction.id}`}
        />
      ))}
    </>
  );
};
