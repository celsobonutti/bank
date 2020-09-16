import 'jest';
import fetchMock from 'jest-fetch-mock';

fetchMock.enableMocks();

const user = {
  name: 'Roberto Baptista',
  balance: 40.0,
  email: 'roberto.baptista@gmail.com',
  id: 45
};

const transactions = [
  {
    type: 'withdrawal',
    quantity: 410.0,
    date: '2020-06-21',
    id: 2
  },
  {
    type: 'deposit',
    quantity: 450.0,
    date: '2020-05-05',
    id: 1
  }
];

//@ts-ignore
fetchMock.mockResponse((req) => {
  switch (req.url) {
    case '/api/v1/users':
      return Promise.resolve(
        JSON.stringify({
          data: user
        })
      );
    case '/api/users/transactions':
      return Promise.resolve(
        JSON.stringify({
          data: transactions
        })
      );
  }
});

import 'regenerator-runtime/runtime';
