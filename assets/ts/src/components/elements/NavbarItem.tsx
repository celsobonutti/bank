import React from 'react';
import { Button } from 'reakit';
import { useHistory, useLocation } from 'react-router-dom';
import clsx from 'clsx';

import { Route } from '../../types/route';

type NavbarItem = {
  to: Route;
  text: string;
};

export const NavbarItem = ({ to, text }: NavbarItem) => {
  const location = useLocation();
  const history = useHistory();

  const isCurrent = location.pathname === to;

  const className = clsx('menu__item', isCurrent && 'menu__item--active');

  return (
    <Button
      onClick={() => {
        history.push(to);
      }}
      className={className}
    >
      {text}
    </Button>
  );
};
