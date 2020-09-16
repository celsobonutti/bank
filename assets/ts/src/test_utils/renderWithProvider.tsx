import React from 'react';
import { render } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import { SnackbarProvider } from '../providers/SnackbarProvider';
import { UserProvider } from '../providers/UserProvider';

export const renderWithProviders = (element: React.ReactNode) => {
  return render(
    <UserProvider>
      <SnackbarProvider>
        <MemoryRouter>{element}</MemoryRouter>
      </SnackbarProvider>
    </UserProvider>
  );
};
