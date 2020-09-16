import React from 'react';
import NumberFormat from 'react-number-format';
import { Controller, useForm } from 'react-hook-form';
import { ErrorMessage } from '@hookform/error-message';
import { Button } from 'reakit';
import { parseMoney } from '../../utils/parseMoney';
import { useCreateDeposit } from '../../hooks/useCreateDeposit';
import { useSnackbar } from '../../providers/SnackbarProvider';

type FormData = {
  quantity: string;
};

export const Form = () => {
  const { handleSubmit, errors, control, reset, setError } = useForm({
    defaultValues: {
      quantity: null
    }
  });

  const { showSnackbar } = useSnackbar();

  const [mutate, { isLoading, error }] = useCreateDeposit({
    onSuccess: () => {
      showSnackbar({
        type: 'success',
        message: 'Seu depósito foi realizado com sucesso! ;)'
      });
      reset();
    },
    onError: (errorList) => {
      for (const key in errorList) {
        errorList[key].forEach((errorMessage: string) =>
          setError(key, { message: errorMessage })
        );
      }
      showSnackbar({
        type: 'error',
        message: 'Opa, parece que houve um erro com seu depósito :('
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
      <h3 data-testid="deposit-header">Fazer um depósito</h3>
      <form className="form deposit__form" onSubmit={handleSubmit(onSubmit)}>
        <label htmlFor="quantity" className="form__label">
          Quantia a ser depositada
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
              data-testid="deposit-input"
            />
          }
          rules={{
            validate: (value) => {
              if (value && parseMoney(value) > 0) {
                return true;
              } else {
                return 'Ops, você tem que depositar algo, não? :(';
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
          data-testid="deposit-button"
        >
          Depositar
        </Button>
      </form>
    </>
  );
};
