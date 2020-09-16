defmodule BankWeb.PaymentController do
  use BankWeb, :controller

  alias Bank.Transactions
  alias Bank.Transactions.Payment
  alias Bank.Accounts.User

  action_fallback BankWeb.FallbackController

  def create(conn, _params) do
    params =
      with %{"boleto_code" => boleto_code} <- conn.body_params do
        %{
          "boleto_code" => boleto_code,
          "user" => conn.assigns[:current_user]
        }
      end

    with {:ok, %Payment{} = payment} <- Transactions.create_payment(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.payment_path(conn, :show, payment.id))
      |> render("show.json", payment: payment)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Transactions.get_payment!(id)

    current_user = conn.assigns[:current_user]

    if payment.user_id == current_user.id do
      render(conn, "show.json", payment: payment)
    else
      {:error, :forbidden}
    end
  end

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      %User{id: user_id} = conn.assigns[:current_user]
       render(conn, "index.json", payments: Transactions.get_user_payments(user_id))
    else
      {:error, :unauthorized}
    end
  end
end
