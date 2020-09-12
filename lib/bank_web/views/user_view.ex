defmodule BankWeb.UserView do
  use BankWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        name: user.name,
        email: user.email,
        balance: Decimal.round(user.balance, 2)
      }
    }
  end
end
