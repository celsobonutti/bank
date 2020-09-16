import React from 'react';

type Snackbar = {
  type: 'success' | 'info' | 'error';
  message: string;
};

type SnackbarContext = {
  showSnackbar: (snackbarToShow: Snackbar, time?: number) => void;
};

const SnackbarContext = React.createContext<SnackbarContext | undefined>(
  undefined
);

type ProviderProps = {
  children: React.ReactNode;
};

export const useSnackbar = () =>
  React.useContext(SnackbarContext) as SnackbarContext;

export const SnackbarProvider = ({ children }: ProviderProps) => {
  const [snackbar, setSnackbar] = React.useState<Snackbar | undefined>(
    undefined
  );

  const showSnackbar = (snackbarToShow: Snackbar, time?: number) => {
    setSnackbar(snackbarToShow);

    setTimeout(() => {
      setSnackbar(undefined);
    }, time ?? 5000);
  };

  return (
    <SnackbarContext.Provider value={{ showSnackbar }}>
      {snackbar && (
        <div className={`snackbar snackbar--${snackbar.type}`}>
          <p aria-live="polite" data-testid="snackbar-message">
            {snackbar.message}
          </p>
        </div>
      )}
      {children}
    </SnackbarContext.Provider>
  );
};
