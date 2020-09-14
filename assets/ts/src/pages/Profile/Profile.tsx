import React from 'react';
import { DefaultView } from '../../components/containers/DefaultView';

import { Main } from './Main';
import { Side } from './Side';

export const Profile = () => {
  return <DefaultView main={<Main />} side={<Side />} />;
};
