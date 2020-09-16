import React from 'react';
import { useProfile } from '../../providers/UserProvider';

export const Side = () => {
  const user = useProfile();

  return (
    <>
      <h3 data-testid="profile-header">Olá, {user.name}, tudo bem?</h3>
      <p>
        Deseja sair da sua conta?{' '}
        <a href="/api/v1/log_out" aria-label="Sair">
          Clique aqui.
        </a>
      </p>
      <h4 data-testid="profile-balance">
        Seu saldo é de{' '}
        <b>
          {Intl.NumberFormat('pt-BR', {
            style: 'currency',
            currency: 'BRL'
          }).format(user.balance)}
        </b>
      </h4>
    </>
  );
};
