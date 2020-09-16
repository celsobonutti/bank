defmodule BankWeb.PaymentController do
  use BankWeb, :controller

  alias Bank.Transactions
  alias Bank.Transactions.Payment

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    payments = Transactions.list_payments()
    render(conn, "index.json", payments: payments)
  end

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
    render(conn, "show.json", payment: payment)
  end
end
