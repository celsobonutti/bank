export const parseMoney = (money: string) => {
  const formatted = money.replace(/(R\$\s|\.+)/g, '').replace(',', '.');
  return Number(formatted);
};
