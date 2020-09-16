import 'jest';
import fetchMock from 'jest-fetch-mock';

fetchMock.enableMocks();

import { user, deposit, transactions } from './ts/src/test_utils/constants';

//@ts-ignore
fetchMock.mockResponse((req) => {
  switch (req.url) {
    case '/api/v1/users':
      return Promise.resolve(
        JSON.stringify({
          data: user
        })
      );
    case '/api/v1/users/transactions':
      return Promise.resolve(
        JSON.stringify({
          data: transactions
        })
      );
    case '/api/v1/users/deposits':
      if (req.method === 'POST') {
        return Promise.resolve(
          JSON.stringify({
            data: deposit
          })
        );
      }
  }
});

import 'regenerator-runtime/runtime';
