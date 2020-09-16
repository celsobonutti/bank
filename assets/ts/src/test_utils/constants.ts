export const user = {
  name: 'Roberto Baptista',
  balance: 40.0,
  email: 'roberto.baptista@gmail.com',
  id: 45
};

export const deposit = {
  quantity: 200,
  id: 1,
  date: '2020-05-10',
  user_id: 45
};

export const transactions = [
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
