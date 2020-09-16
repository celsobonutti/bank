import React from 'react';
import { Group } from 'reakit';
import { Route } from '../../types/route';

import { NavbarItem } from './NavbarItem';

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
  },
  {
    path: '/payment',
    title: 'Pagamentos'
  }
];

export const Navbar = () => {
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
