defmodule BankWeb.UserController do
  use BankWeb, :controller

  action_fallback BankWeb.FallbackController

  def show(conn, _opts) do
    render(conn, "show.json", user: conn.assigns[:current_user])
  end

  def show_transactions(conn, _opts) do
    transactions = Bank.Accounts.get_user_transactions(conn.assigns[:current_user].id)

    render(conn, "transactions.json", transactions: transactions)
  end
end
