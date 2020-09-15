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
  code: string;
  scheduled_at: string;
  status: 'scheduled' | 'paid' | 'failed';
  paid_at: string | undefined;
};
