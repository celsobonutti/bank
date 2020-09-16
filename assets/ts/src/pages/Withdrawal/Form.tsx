import React from 'react';
import NumberFormat from 'react-number-format';
import { Controller, useForm } from 'react-hook-form';
import { ErrorMessage } from '@hookform/error-message';
import { Button } from 'reakit';
import { parseMoney } from '../../utils/parseMoney';
import { useCreateWithdrawal } from '../../hooks/useCreateWithdrawal';
import { useSnackbar } from '../../providers/SnackbarProvider';
import { useProfile } from '../../providers/UserProvider';

type FormData = {
  quantity: string;
};

export const Form = () => {
  const { handleSubmit, errors, control, reset } = useForm({
    defaultValues: {
      quantity: null
    }
  });

  const { showSnackbar } = useSnackbar();

  const user = useProfile();

  const [mutate, { isLoading, error }] = useCreateWithdrawal({
    onSuccess: () => {
      showSnackbar({
        type: 'success',
        message: 'Seu saque foi realizado com sucesso! ;)'
      });
      reset();
    },
    onError: () => {
      showSnackbar({
        type: 'error',
        message: (error as any).toString()
      });
    }
  });

  const onSubmit = (formData: FormData) => {
    if (isLoading) {
      return;
    } else {
      const quantity = parseMoney(formData.quantity);
      mutate(quantity);
    }
  };

  return (
    <>
      <h3 data-testid="withdrawal-header">Fazer um saque</h3>
      <form className="form withdrawal__form" onSubmit={handleSubmit(onSubmit)}>
        <label htmlFor="quantity" className="form__label">
          Quantia a ser retirada
        </label>
        <Controller
          name="quantity"
          control={control}
          as={
            <NumberFormat
              className="form__input"
              prefix={'R$ '}
              decimalScale={2}
              fixedDecimalScale
              decimalSeparator=","
              thousandSeparator="."
              placeholder="R$ 0,00"
              data-testid="withdrawal-input"
            />
          }
          rules={{
            validate: (value) => {
              if (!value || parseMoney(value) < 0) {
                return 'Ops, você tem que sacar algo, não? :(';
              } else if (parseMoney(value) > user.balance) {
                return 'Opa, parece que você tentou sacar um valor maior do que saldo. :(';
              } else {
                return true;
              }
            }
          }}
        />
        <ErrorMessage
          name="quantity"
          as={<span className="form__error" />}
          errors={errors}
        />

        <Button
          type="submit"
          className="form__button"
          data-testid="withdrawal-button"
        >
          Sacar
        </Button>
      </form>
    </>
  );
};
