import React from 'react';
import { DefaultView } from '../../components/containers/DefaultView';

import { User } from '../../types/user';

type ProfileProps = {
  user: User;
};

export const Profile = ({ user }: ProfileProps) => {
  return (
    <DefaultView
      main={
        <>
          <h1>Olá, {user.name}, tudo bem?</h1>
          <h2>
            Seu saldo é de{' '}
            <b>
              {Intl.NumberFormat('pt-BR', {
                style: 'currency',
                currency: 'BRL'
              }).format(user.balance)}
            </b>
          </h2>
        </>
      }
      side={<h3>Histórico de transações</h3>}
    />
  );
};
