defmodule BankWeb.WithdrawalView do
  use BankWeb, :view
  alias BankWeb.WithdrawalView

  def render("index.json", %{withdrawals: withdrawals}) do
    %{data: render_many(withdrawals, WithdrawalView, "withdrawal.json")}
  end

  def render("show.json", %{withdrawal: withdrawal}) do
    %{data: render_one(withdrawal, WithdrawalView, "withdrawal.json")}
  end

  def render("withdrawal.json", %{withdrawal: withdrawal}) do
    %{id: withdrawal.id,
      user_id: withdrawal.user_id,
      quantity: withdrawal.quantity,
      date: NaiveDateTime.to_string(withdrawal.inserted_at)
    }
  end
end
