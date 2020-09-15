import React from 'react';
import { MemoryRouter } from 'react-router-dom';
import { render, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom/extend-expect';
import fetchMock from 'jest-fetch-mock';

import { Router as AppRouter } from '../Router';
import { UserProvider } from '../../../providers/UserProvider';
import { SnackbarProvider } from '../../../providers/SnackbarProvider';

const user = {
  name: 'Roberto Baptista',
  balance: 40.0,
  email: 'roberto.baptista@gmail.com',
  id: 45
};

describe('<Router />', () => {
  test('app rendering/navigating', async () => {
    fetchMock.mockResponse(
      JSON.stringify({
        data: user
      })
    );

    const { getByText, getByTestId } = render(
      <UserProvider>
        <SnackbarProvider>
          <MemoryRouter>
            <AppRouter />
          </MemoryRouter>
        </SnackbarProvider>
      </UserProvider>
    );

    await waitFor(() => getByText('Perfil'));

    const profileButton = getByText('Perfil');
    const depositButton = getByText('Depósitos');
    const withdrawalButton = getByText('Saques');
    const profileHeader = getByTestId('profile-header');
    const profileBalance = getByTestId('profile-balance');

    expect(profileButton).toHaveClass('menu__item--active');
    expect(depositButton).not.toHaveClass('menu__item--active');
    expect(withdrawalButton).not.toHaveClass('menu__item--active');
    expect(profileHeader).toHaveTextContent(
      'Olá, ' + user.name + ', tudo bem?'
    );
    expect(profileBalance).toHaveTextContent('Seu saldo é de ');

    fireEvent.click(depositButton);

    const depositHeader = getByTestId('deposit-header');

    expect(depositButton).toHaveClass('menu__item--active');
    expect(depositHeader).toHaveTextContent('Fazer um depósito');

    fireEvent.click(withdrawalButton);

    const withdrawalHeader = getByTestId('withdrawal-header');

    expect(withdrawalButton).toHaveClass('menu__item--active');
    expect(withdrawalHeader).toHaveTextContent('Fazer um saque');
  });
});
