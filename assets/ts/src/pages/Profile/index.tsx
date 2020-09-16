import React from 'react';
import { DefaultView } from '../../components/containers/DefaultView';

import { TransactionHistory } from './TransactionHistory';
import { Summary } from './Summary';

export const Profile = () => {
  return <DefaultView main={<TransactionHistory />} side={<Summary />} />;
};
