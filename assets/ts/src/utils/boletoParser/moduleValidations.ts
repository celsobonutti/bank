import { BoletoFields } from './boletoParser';

const splitLast = (input: string): [string, string] => {
  const everyButLast = input.slice(0, input.length - 1);
  const lastDigit = input.slice(-1);

  return [everyButLast, lastDigit];
};

const extractBankAndCurrency = (code: string) => {
  const bankCode = code.slice(0, 3);
  const currencyCode = code.slice(3, 4);
  const barcode = code.slice(4, 9);
  return {
    bankCode,
    currencyCode,
    barcode
  };
};

export const extractBarcodeString = ([
  first,
  second,
  third,
  _,
  paymentInfo
]: BoletoFields): string => {
  const [codes, _firstDV] = splitLast(first);
  const { bankCode, barcode, currencyCode } = extractBankAndCurrency(codes);
  const [secondPart, _secondDV] = splitLast(second);
  const [thirdPart, _thirdDV] = splitLast(third);

  return (
    bankCode + currencyCode + paymentInfo + barcode + secondPart + thirdPart
  );
};

export const module10Validation = (codeToValidate: string): boolean => {
  const [everyButLast, last] = splitLast(codeToValidate);

  const sum: number = everyButLast
    .split('')
    .reverse()
    .reduce((accumulator, currentValue, index) => {
      let multiplyingFactor = 2 - (index % 2);
      let valueToSum = Number(currentValue) * multiplyingFactor;

      valueToSum =
        valueToSum > 9
          ? Math.trunc(valueToSum / 10) + (valueToSum % 10)
          : valueToSum;

      return accumulator + valueToSum;
    }, 0);

  let sub = Math.ceil(sum / 10) * 10 - sum;

  sub = sub === 10 ? 0 : sub;

  return sub === Number(last);
};

export const module11Validation = (boleto: BoletoFields): boolean => {
  const barcode = extractBarcodeString(boleto);

  const [sum, _] = barcode
    .split('')
    .reverse()
    .reduce(
      ([accumulator, multiplier], currentValue) => {
        const valueToSum = Number(currentValue) * multiplier;
        const newMultiplier = multiplier === 9 ? 2 : multiplier + 1;
        return [accumulator + valueToSum, newMultiplier];
      },
      [0, 2]
    );

  const rem = sum % 11;

  let validationDigit = 11 - rem;
  validationDigit =
    validationDigit === 0 || validationDigit === 10 || validationDigit === 11
      ? 1
      : validationDigit;

  return validationDigit === Number(boleto[3]);
};
