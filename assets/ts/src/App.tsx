import React from 'react';
import { hot } from 'react-hot-loader';

const AppComponent = () => {
  return <h1>Welcome to React</h1>;
};

export const App = hot(module)(AppComponent);