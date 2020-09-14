defmodule BankWeb.UserView do
  use BankWeb, :view

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
end
