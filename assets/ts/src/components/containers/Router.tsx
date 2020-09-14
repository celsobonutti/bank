import React from 'react';
import { Route, Switch } from 'react-router-dom';
import { Deposit } from '../../pages/Deposit/Deposit';
import { Profile } from '../../pages/Profile/Profile';
import { useProfile } from '../../providers/UserProvider';
import { Navbar } from '../elements/Navbar';

export const Router = () => {
  const user = useProfile();

  return (
    <>
      <Navbar user={user} />
      <Switch>
        <Route exact path="/">
          <Profile user={user} />
        </Route>
        <Route path="/deposit">
          <Deposit />
        </Route>
      </Switch>
    </>
  );
};
