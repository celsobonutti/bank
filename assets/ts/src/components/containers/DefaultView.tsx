import React, { ReactNode } from 'react';

type DefaultViewProps = {
  main: ReactNode;
  side: ReactNode;
};

export const DefaultView = ({ main, side }: DefaultViewProps) => {
  return (
    <div className="view">
      <main className="main">{main}</main>
      <aside className="side">{side}</aside>
    </div>
  );
};
