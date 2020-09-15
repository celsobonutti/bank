import React from 'react';
import { hot } from 'react-hot-loader';
import { BrowserRouter } from 'react-router-dom';

import { UserProvider } from './providers/UserProvider';
import { SnackbarProvider } from './providers/SnackbarProvider';
import { Router } from './components/containers/Router';

const AppComponent = () => {
  return (
    <UserProvider>
      <SnackbarProvider>
        <BrowserRouter basename="/app">
          <Router />
        </BrowserRouter>
      </SnackbarProvider>
    </UserProvider>
  );
};

export const App = hot(module)(AppComponent);
