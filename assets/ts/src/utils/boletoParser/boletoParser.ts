import { module10Validation, module11Validation } from './moduleValidations';

export type Boleto =
  | {
      valid: true;
      dueDate: Date;
      value: number;
    }
  | {
      valid: false;
    };

export type BoletoFields = [
  firstPart: string,
  secondPart: string,
  thirdPart: string,
  validationDigit: string,
  paymentInfo: string
];

const parsePaymentInfo = (paymentInfo: string) => {
  const days = Number(paymentInfo.slice(0, 4));
  const baseDate = new Date(1997, 9, 7);
  const dueDate = baseDate;
  dueDate.setDate(dueDate.getDate() + days);

  const value = Number(paymentInfo.slice(4)) / 100;

  return {
    dueDate,
    value
  };
};

const boletoSplit = (boleto: string): BoletoFields | false => {
  if (!boleto.match(/^\d{5}\.\d{5} \d{5}\.\d{6} \d{5}\.\d{6} \d \d{14}$/)) {
    return false;
  }
  const fields = boleto.replace(/\.+/g, '').split(' ');
  return fields as BoletoFields;
};

export const parseBoleto = (boleto: string): Boleto => {
  const fields = boletoSplit(boleto);
  if (fields) {
    const [first, second, third, _, paymentInfo] = fields;
    if (
      [first, second, third].every((code) => module10Validation(code)) &&
      module11Validation(fields)
    ) {
      const { dueDate, value } = parsePaymentInfo(paymentInfo);

      return {
        valid: true,
        dueDate,
        value
      };
    } else {
      return {
        valid: false
      };
    }
  } else {
    return {
      valid: false
    };
  }
};
