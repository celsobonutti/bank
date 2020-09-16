import { BoletoFields, parseBoleto } from '../boletoParser/boletoParser';
import {
  extractBarcodeString,
  module10Validation,
  module11Validation
} from '../boletoParser/moduleValidations';

const boleto: BoletoFields = [
  '2379338128',
  '60037265885',
  '60000063309',
  '6',
  '83680000083151'
];

const secondBoleto: BoletoFields = [
  '2379338128',
  '60030557163',
  '65000063308',
  '4',
  '83080000058584'
];

const falseBoleto: BoletoFields = [
  '2379338148',
  '60037262285',
  '60000063709',
  '4',
  '83620000083151'
];

describe('module10 validation', () => {
  test('10 digits code', () => {
    expect(module10Validation('0019050095')).toBe(true);
    expect(module10Validation('3419175439')).toBe(true);
    expect(module10Validation('0019050094')).toBe(false);
    expect(module10Validation('3419175432')).toBe(false);
  });

  test('11 digits code', () => {
    expect(module10Validation('26160772930')).toBe(true);
    expect(module10Validation('81898480009')).toBe(true);
    expect(module10Validation('98129481294')).toBe(false);
    expect(module10Validation('29499492919')).toBe(false);
  });
});

describe('module11 validation', () => {
  test('extraction of barcode string', () => {
    expect(extractBarcodeString(boleto)).toBe(
      '2379836800000831513381260037265886000006330'
    );
  });

  test('validation of the boleto', () => {
    expect(module11Validation(boleto)).toBe(true);
    expect(module11Validation(secondBoleto)).toBe(true);
    expect(module11Validation(falseBoleto)).toBe(false);
  });
});

describe('boleto parser', () => {
  test('parses a valid boleto', () => {
    const parsedBoleto = parseBoleto(
      '23793.38128 60030.557163 65000.063308 4 83080000058584'
    );

    expect(parsedBoleto.valid).toBe(true);
    if (parsedBoleto.valid) {
      expect(parsedBoleto.dueDate.getDate()).toBe(6);
      expect(parsedBoleto.dueDate.getMonth()).toBe(6);
      expect(parsedBoleto.dueDate.getFullYear()).toBe(2020);
      expect(parsedBoleto.value).toBe(585.84);
    }
  });

  test('returns invalid boleto', () => {
    expect(parseBoleto('1243870912480912408')).toStrictEqual({
      valid: false
    });

    expect(parseBoleto('com letras')).toStrictEqual({
      valid: false
    });

    expect(
      parseBoleto('23793.38128 60030.557163 65000.063308 2 83080000058584')
    ).toStrictEqual({
      valid: false
    });
  });
});
