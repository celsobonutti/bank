import React from 'react';
import { Group } from 'reakit';
import { Route } from '../../types/route';

import { User } from '../../types/user';
import { NavbarItem } from './NavbarItem';

type MenuProps = {
  user: User;
};

type Item = {
  path: Route;
  title: string;
};

const routes: Item[] = [
  {
    path: '/',
    title: 'Perfil'
  },
  {
    path: '/deposit',
    title: 'Depósitos'
  },
  {
    path: '/withdrawal',
    title: 'Saques'
  }
];

export const Navbar = ({ user }: MenuProps) => {
  return (
    <nav className="menu">
      <Group className="menu__group">
        {routes.map((route) => (
          <NavbarItem
            text={route.title}
            to={route.path}
            key={`navbar::item::${route.path}`}
          />
        ))}
      </Group>
    </nav>
  );
};
