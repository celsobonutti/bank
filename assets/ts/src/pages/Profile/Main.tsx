import React from 'react';
import { useProfile } from '../../providers/UserProvider';

export const Main = () => {
  const user = useProfile();

  return (
    <>
      <h1 data-testid="profile-header">Olá, {user.name}, tudo bem?</h1>
      <h2 data-testid="profile-balance">
        Seu saldo é de{' '}
        <b>
          {Intl.NumberFormat('pt-BR', {
            style: 'currency',
            currency: 'BRL'
          }).format(user.balance)}
        </b>
      </h2>
    </>
  );
};
