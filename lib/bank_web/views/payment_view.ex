defmodule BankWeb.PaymentView do
  use BankWeb, :view
  alias BankWeb.PaymentView

  def render("index.json", %{payments: payments}) do
    %{data: render_many(payments, PaymentView, "payment.json")}
  end

  def render("show.json", %{payment: payment}) do
    %{data: render_one(payment, PaymentView, "payment.json")}
  end

  def render("payment.json", %{payment: payment}) do
    %{
      id: payment.id,
      user_id: payment.user_id,
      quantity: payment.quantity,
      boleto_code: payment.boleto_code,
      date: NaiveDateTime.to_string(payment.inserted_at)
    }
  end
end
