import 'regenerator-runtime/runtime';
import React from 'react';
import ReactDOM from 'react-dom';

import '../css/app.scss';

import { App } from './src/App';

ReactDOM.render(<App />, document.getElementById('react'));

//@ts-ignore
module.hot.accept();
