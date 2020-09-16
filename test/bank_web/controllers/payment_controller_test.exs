defmodule BankWeb.PaymentControllerTest do
  @moduledoc """
  Payment controller tests.
  As boletos expire, please replace the @valid_boleto value with a new one before running tests.
  """

  use BankWeb.ConnCase

  import Bank.AccountsFixtures

  # Replace with a valid one before running tests
  # @valid_boleto "23793.38128 60039.354695 59000.063301 7 83810000020000"
  @valid_expired_boleto "23793.38128 60030.557163 65000.063308 4 83080000058584"
  @invalid_boleto "23793.38128 60030.557163 65000.063308 3 83080000058584"

  setup do
    %{user: user_with_balance_fixture()}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create payment" do
    # test "renders payment when data is valid", %{conn: conn, user: user} do
    #   conn = conn |> log_in_user(user) |> post(Routes.payment_path(conn, :create), boleto_code: @valid_boleto)
    #   assert %{"id" => id} = json_response(conn, 201)["data"]

    #   conn = get(conn, Routes.payment_path(conn, :show, id))

    #   assert %{
    #            "id" => id,
    #            "boleto_code" => @valid_boleto,
    #            "quantity" => "200"
    #          } = json_response(conn, 200)["data"]
    # end

    test "renders errors when boleto is valid but expired", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.payment_path(conn, :create), boleto_code: @valid_expired_boleto)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.payment_path(conn, :create), boleto_code: @invalid_boleto)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "fetch users payments" do
  #   test "renders all of the users payments, in order", %{conn: conn, user: user} do
  #     conn = conn |> log_in_user(user) |> post(Routes.payment_path(conn, :create), boleto_code: @valid_boleto)

  #     assert payment = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.payment_path(conn, :index))

  #     assert [
  #       payment
  #     ] = json_response(conn, 200)["data"]
  #   end
  # end
end
