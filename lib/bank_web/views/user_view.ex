defmodule BankWeb.UserView do
  use BankWeb, :view
  alias BankWeb.UserView

  def render("show.json", %{user: user}) do
    balance =
      user.balance
      |> Decimal.round(2)
      |> Decimal.to_float()

    %{
      data: %{
        id: user.id,
        name: user.name,
        email: user.email,
        balance: balance
      }
    }
  end

  def render("transactions.json", %{transactions: transactions}) do
    %{
      data:
        transactions
        |> Enum.map(fn transaction ->
          %{
            type: transaction.type,
            id: transaction.id,
            quantity: transaction.quantity,
            date: NaiveDateTime.to_string(transaction.date),
            boleto_code: transaction.code
          }
        end)
    }
  end
end
