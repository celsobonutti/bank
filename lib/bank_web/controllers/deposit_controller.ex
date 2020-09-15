defmodule BankWeb.DepositController do
  use BankWeb, :controller

  alias Bank.Transactions
  alias Bank.Transactions.Deposit
  alias Bank.Accounts.User

  action_fallback BankWeb.FallbackController

  def create(conn, _params) do
    params =
      with %{"quantity" => quantity} <- conn.body_params do
        %{
          "quantity" => quantity,
          "user" => conn.assigns[:current_user]
        }
      end

    with {:ok, %Deposit{} = deposit} <- Transactions.create_deposit(params) do
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

  def index(conn, _params) do
    if %User{id: user_id} = conn.assigns[:current_user] do
       render(conn, "index.json", deposits: Transactions.get_user_deposits(user_id))
    else
      {:error, :unauthorized}
    end
  end
end
