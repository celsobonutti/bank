defmodule BankWeb.PaymentController do
  use BankWeb, :controller

  alias Bank.Transactions
  alias Bank.Transactions.Payment

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    payments = Transactions.list_payments()
    render(conn, "index.json", payments: payments)
  end

  def create(conn, %{"payment" => payment_params}) do
    with {:ok, %Payment{} = payment} <- Transactions.create_payment(payment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.payment_path(conn, :show, payment))
      |> render("show.json", payment: payment)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Transactions.get_payment!(id)
    render(conn, "show.json", payment: payment)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Transactions.get_payment!(id)

    with {:ok, %Payment{} = payment} <- Transactions.update_payment(payment, payment_params) do
      render(conn, "show.json", payment: payment)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Transactions.get_payment!(id)

    with {:ok, %Payment{}} <- Transactions.delete_payment(payment) do
      send_resp(conn, :no_content, "")
    end
  end
end
