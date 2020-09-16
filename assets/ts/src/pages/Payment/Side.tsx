import { ErrorMessage } from '@hookform/error-message';
import React from 'react';
import { Controller, useForm } from 'react-hook-form';
import NumberFormat from 'react-number-format';
import { Button } from 'reakit';
import { useCreatePayment } from '../../hooks/useCreatePayment';
import { useSnackbar } from '../../providers/SnackbarProvider';
import { useProfile } from '../../providers/UserProvider';
import { parseBoleto } from '../../utils/boletoParser/boletoParser';

type FormData = {
  boleto_code: string;
};

type BoletoFields = {
  dueDate: string;
  value: string;
};

export const Side = () => {
  const { handleSubmit, errors, control, reset } = useForm({
    defaultValues: {
      boleto_code: null
    }
  });

  const [boletoFields, setBoletoFields] = React.useState<BoletoFields>({
    dueDate: '',
    value: ''
  });

  const { showSnackbar } = useSnackbar();

  const user = useProfile();

  const [mutate, { isLoading, error }] = useCreatePayment({
    onSuccess: () => {
      showSnackbar({
        type: 'success',
        message: 'Seu pagamento foi realizado com sucesso! ;)'
      });
      reset();
      setBoletoFields({
        dueDate: '',
        value: ''
      });
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
      mutate(formData.boleto_code);
    }
  };

  return (
    <>
      <h3 data-testid="payment-header">Fazer um pagamento</h3>
      <form className="form payment__form" onSubmit={handleSubmit(onSubmit)}>
        <label htmlFor="boleto_code" className="form__label">
          Digite o código (Linha Digitável) do seu boleto
        </label>
        <Controller
          name="boleto_code"
          control={control}
          render={({ onChange, onBlur, value, name }) => {
            return (
              <NumberFormat
                className="form__input"
                placeholder="#####.##### #####.###### #####.###### # ###########"
                format="#####.##### #####.###### #####.###### # ##############"
                data-testid="payment-input"
                onBlur={onBlur}
                value={value}
                name={name}
                onChange={(val) => {
                  const boleto = parseBoleto(val.target.value);
                  if (boleto.valid) {
                    setBoletoFields({
                      dueDate: Intl.DateTimeFormat('pt-BR').format(
                        new Date(boleto.dueDate)
                      ),
                      value: Intl.NumberFormat('pt-BR', {
                        style: 'currency',
                        currency: 'BRL'
                      }).format(boleto.value)
                    });
                  } else if (boletoFields.dueDate || boletoFields.value) {
                    setBoletoFields({
                      dueDate: '',
                      value: ''
                    });
                  }
                  onChange(val);
                }}
              />
            );
          }}
          rules={{
            validate: (value) => {
              if (value) {
                const boleto = parseBoleto(value);
                if (boleto.valid) {
                  if (boleto.value > user.balance) {
                    return 'Opa, o valor do seu boleto excede o seu saldo. :(';
                  } else {
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);

                    if (boleto.dueDate < today) {
                      return 'Seu boleto está expirado.';
                    } else {
                      return true;
                    }
                  }
                } else {
                  return 'Oops, seu boleto não é válido. :/';
                }
              } else {
                return 'Por favor, digite o código de seu boleto.';
              }
            }
          }}
        />
        <ErrorMessage name="boleto_code" errors={errors} />
        <label htmlFor="value" className="form__label">
          Valor:
        </label>
        <input name="value" type="text" disabled value={boletoFields.value} />

        <label htmlFor="due_date" className="form__label">
          Vence em:
        </label>
        <input
          name="due_date"
          type="text"
          disabled
          value={boletoFields.dueDate}
        />

        <Button
          type="submit"
          className="form__button"
          data-testid="payment-button"
        >
          Pagar
        </Button>
      </form>
    </>
  );
};
