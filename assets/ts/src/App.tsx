import React from 'react';
import { hot } from 'react-hot-loader';

const AppComponent = () => {
  return (
    <div>
      <h1>Welcome to React</h1>
      <p>
        <a href="/api/log_out">Sair</a>
      </p>
    </div>
  );
};

export const App = hot(module)(AppComponent);
