import React from 'react';
import { Router } from 'react-router-dom';
import { createMemoryHistory } from 'history';
import { render, fireEvent } from '@testing-library/react';
import '@testing-library/jest-dom/extend-expect';
import fetchMock from 'jest-fetch-mock';

import { Router as AppRouter } from '../Router';
import { User } from '../../../types/user';

describe('<Router />', () => {
  test('app rendering/navigating', () => {
    const history = createMemoryHistory();

    fetchMock.mockResponse(
      JSON.stringify({
        data: {
          name: 'Roberto Baptista',
          balance: 40.0,
          email: 'roberto.baptista@gmail.com',
          id: 45
        }
      })
    );

    const { getByText } = render(
      <Router history={history}>
        <AppRouter />
      </Router>
    );

    const profileButton = getByText('Perfil');
    const depositButton = getByText('Depósitos');

    expect(profileButton).toHaveClass('menu__item--active');
  });
});
