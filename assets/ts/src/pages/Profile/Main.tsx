import React from 'react';
import { TransactionCard } from '../../components/elements/TransactionCard';

import { useTransactions } from '../../hooks/useTransactions';

export const Main = () => {
  const { isLoading, data } = useTransactions();

  if (isLoading) {
    return <p>Loading...</p>;
  }

  console.log(data);

  return (
    <>
      <h3>Histórico de transações</h3>
      {data?.map((transaction) => (
        <TransactionCard type={transaction.type} data={transaction} />
      ))}
    </>
  );
};
