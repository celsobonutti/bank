import { parseMoney } from '../parseMoney';

describe('parseMoney(money: string)', () => {
  test('parses 0 reais correctly', () => {
    const money = parseMoney('R$ 0,00');
    expect(money).toBe(0);
  });

  test('parses numbers with thousands', () => {
    const money = parseMoney('R$ 1.450,00');
    expect(money).toBe(1450);
  });

  test('parses number with more than one thousand separator', () => {
    const money = parseMoney('R$ 1.200.450,25');
    expect(money).toBe(1200450.25);
  });
});
