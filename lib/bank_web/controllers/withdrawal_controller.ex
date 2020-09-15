defmodule BankWeb.WithdrawalController do
  use BankWeb, :controller

  alias Bank.Transactions
  alias Bank.Transactions.Withdrawal
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

    with {:ok, %Withdrawal{} = withdrawal} <- Transactions.create_withdrawal(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.withdrawal_path(conn, :show, withdrawal.id))
      |> render("show.json", withdrawal: withdrawal)
    end
  end

  def show(conn, %{"id" => id}) do
    withdrawal = Transactions.get_withdrawal!(id)

    current_user = conn.assigns[:current_user]

    if withdrawal.user_id == current_user.id do
      render(conn, "show.json", withdrawal: withdrawal)
    else
      {:error, :forbidden}
    end
  end

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      %User{id: user_id} = conn.assigns[:current_user]
       render(conn, "index.json", withdrawals: Transactions.get_user_withdrawals(user_id))
    else
      {:error, :unauthorized}
    end
  end
end
