import React from 'react';
import { DefaultView } from '../../components/containers/DefaultView';
import { List } from './List';
import { Form } from './Form';

export const Payment = () => {
  return <DefaultView main={<List />} side={<Form />} />;
};
