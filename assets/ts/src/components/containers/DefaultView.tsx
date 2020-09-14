import React, { ReactNode } from 'react';

type DefaultViewProps = {
  main: ReactNode;
  side: ReactNode;
};

export const DefaultView = ({ main, side }: DefaultViewProps) => {
  return (
    <main className="view">
      <section className="main">{main}</section>
      <section className="side">{side}</section>
    </main>
  );
};
