import React from 'react';
import { Route, Switch } from 'react-router-dom';
import { Deposit, Profile, Withdrawal } from '../../pages';
import { useProfile } from '../../providers/UserProvider';
import { Navbar } from '../elements/Navbar';

export const Router = () => {
  const user = useProfile();

  return (
    <>
      <Navbar user={user} />
      <Switch>
        <Route exact path="/" component={Profile} />
        <Route path="/deposit" component={Deposit} />
        <Route path="/withdrawal" component={Withdrawal} />
      </Switch>
    </>
  );
};
