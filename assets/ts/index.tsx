import 'regenerator-runtime/runtime';
import React from 'react';
import ReactDOM from 'react-dom';
import IMask from 'imask';

import { App } from './src/App';

const app = document.getElementById('app');

const documentInput = document.getElementById('user_document');

if (app) {
  ReactDOM.render(<App />, document.getElementById('app'));

  //@ts-ignore
  module.hot.accept();
}

if (documentInput) {
  const maskOption = {
    mask: '000.000.000-00'
  };
  IMask(documentInput, maskOption);
}
