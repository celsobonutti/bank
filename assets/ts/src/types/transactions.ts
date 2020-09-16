export type Deposit = {
  id: number;
  user_id: number;
  quantity: number;
  date: string;
};

export type Withdrawal = {
  id: number;
  user_id: number;
  quantity: number;
  date: string;
};

export type Payment = {
  id: number;
  user_id: number;
  quantity: number;
  boleto_code: string;
  date: string;
};
