import React from 'react';
import { MemoryRouter } from 'react-router-dom';
import { render, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom/extend-expect';
//import fetchMock from 'jest-fetch-mock';

import { Router as AppRouter } from '../Router';
import { UserProvider } from '../../../providers/UserProvider';
import { SnackbarProvider } from '../../../providers/SnackbarProvider';
import { act } from 'react-dom/test-utils';

const user = {
  name: 'Roberto Baptista',
  balance: 40.0,
  email: 'roberto.baptista@gmail.com',
  id: 45
};

describe('<Router />', () => {
  test('app rendering/navigating', async () => {
    await act(async () => {
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
      const paymentButton = getByText('Pagamentos');
      const profileHeader = getByTestId('profile-header');
      const profileBalance = getByTestId('profile-balance');

      expect(profileButton).toHaveClass('menu__item--active');
      expect(depositButton).not.toHaveClass('menu__item--active');
      expect(withdrawalButton).not.toHaveClass('menu__item--active');
      expect(paymentButton).not.toHaveClass('menu__item--active');

      expect(profileHeader).toHaveTextContent(
        'Olá, ' + user.name + ', tudo bem?'
      );
      expect(profileBalance).toHaveTextContent('Seu saldo é de ');

      act(() => {
        fireEvent.click(depositButton);
      });

      const depositHeader = getByTestId('deposit-header');

      expect(depositButton).toHaveClass('menu__item--active');
      expect(depositHeader).toHaveTextContent('Fazer um depósito');
      act(() => {
        fireEvent.click(withdrawalButton);
      });

      const withdrawalHeader = getByTestId('withdrawal-header');

      expect(withdrawalButton).toHaveClass('menu__item--active');
      expect(withdrawalHeader).toHaveTextContent('Fazer um saque');
      act(() => {
        fireEvent.click(paymentButton);
      });

      const paymentHeader = getByTestId('payment-header');

      expect(paymentButton).toHaveClass('menu__item--active');
      expect(paymentHeader).toHaveTextContent('Fazer um pagamento');
    });
  });
});
