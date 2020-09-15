import React from 'react';
import { Deposit, Payment, Withdrawal } from '../../types/transactions';

type DepositProp = {
  type: 'deposit';
  data: Deposit;
};

type WithdrawalProp = {
  type: 'withdrawal';
  data: Withdrawal;
};

type PaymentProp = {
  type: 'payment';
  data: Payment;
};

type TransactionCardProps = DepositProp | WithdrawalProp | PaymentProp;

export const TransactionCard = ({ type, data }: TransactionCardProps) => {
  const content = () => {
    switch (type) {
      case 'deposit':
        const deposit = data as Deposit;
        return (
          <>
            <h3>Depósito</h3>
            <h4>
              No valor de{' '}
              {Intl.NumberFormat('pt-BR', {
                style: 'currency',
                currency: 'BRL'
              }).format(data.quantity)}
            </h4>
            <h5>
              Realizado em{' '}
              <b>
                {Intl.DateTimeFormat('pt-BR').format(new Date(deposit.date))}
              </b>
            </h5>
          </>
        );
      case 'withdrawal':
        const withdrawal = data as Withdrawal;
        return (
          <>
            <h3>Saque</h3>
            <h4>
              No valor de:{' '}
              {Intl.NumberFormat('pt-BR', {
                style: 'currency',
                currency: 'BRL'
              }).format(data.quantity)}
            </h4>
            <h5>
              Realizado em{' '}
              <b>
                {Intl.DateTimeFormat('pt-BR').format(new Date(withdrawal.date))}
              </b>
            </h5>
          </>
        );
      case 'payment':
        return (
          <>
            <h3>Pagamento</h3>
            <h4>
              No valor de:{' '}
              {Intl.NumberFormat('pt-BR', {
                style: 'currency',
                currency: 'BRL'
              }).format(data.quantity)}
            </h4>
            <h5>Programado às {(data as Payment).scheduled_at.toString()}</h5>
          </>
        );
    }
  };
  return (
    <div className={`transaction transaction__card--${type}`}>{content()}</div>
  );
};
