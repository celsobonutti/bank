import React from 'react';
import { hot } from 'react-hot-loader';
import { UserProvider } from './providers/UserProvider';
import { BrowserRouter } from 'react-router-dom';

import { Router } from './components/containers/Router';

const AppComponent = () => {
  return (
    <UserProvider>
      <BrowserRouter basename="/app">
        <Router />
      </BrowserRouter>
    </UserProvider>
  );
};

export const App = hot(module)(AppComponent);
