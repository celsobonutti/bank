defmodule BankWeb.DepositView do
  use BankWeb, :view
  alias BankWeb.DepositView

  def render("show.json", %{deposit: deposit}) do
    %{data: render_one(deposit, DepositView, "deposit.json")}
  end

  def render("deposit.json", %{deposit: deposit}) do
    %{id: deposit.id,
      user_id: deposit.user_id,
      quantity: deposit.quantity}
  end
end
