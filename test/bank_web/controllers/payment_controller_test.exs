defmodule BankWeb.PaymentControllerTest do
  use BankWeb.ConnCase

  alias Bank.Transactions
  alias Bank.Transactions.Payment

  import Bank.AccountsFixtures

  @valid_boleto "23793.38128 60039.354695 59000.063301 7 83810000020000"
  @valid_expired_boleto "23793.38128 60030.557163 65000.063308 4 83080000058584"
  @invalid_boleto "23793.38128 60030.557163 65000.063308 3 83080000058584"

  setup do
    %{user: user_fixture()}
  end

  def fixture(:payment) do
    {:ok, payment} = Transactions.create_payment(@create_attrs)
    payment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payments", %{conn: conn} do
      conn = get(conn, Routes.payment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment" do
    test "renders payment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.payment_path(conn, :create), payment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.payment_path(conn, :show, id))

      assert %{
               "id" => id,
               "boleto_code" => "some boleto_code",
               "quantity" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.payment_path(conn, :create), payment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_payment(_) do
    payment = fixture(:payment)
    %{payment: payment}
  end
end
