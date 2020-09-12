defmodule BankWeb.DepositController do
  use BankWeb, :controller

  alias Bank.Transactions
  alias Bank.Transactions.Deposit

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    deposits = Transactions.list_deposits()
    render(conn, "index.json", deposits: deposits)
  end

  def create(conn, %{"deposit" => deposit_params}) do
    with {:ok, %Deposit{} = deposit} <- Transactions.create_deposit(deposit_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deposit_path(conn, :show, deposit.id))
      |> render("show.json", deposit: deposit)
    end
  end

  def show(conn, %{"id" => id}) do
    deposit = Transactions.get_deposit!(id)

    current_user = conn.assigns[:current_user]

    if deposit.user_id == current_user.id do
      render(conn, "show.json", deposit: deposit)
    else
      {:error, :forbidden}
    end
  end
end
