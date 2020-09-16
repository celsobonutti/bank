defmodule BankWeb.WithdrawalControllerTest do
  use BankWeb.ConnCase

  alias Bank.Transactions
  import Bank.AccountsFixtures

  setup do
    %{user: user_with_balance_fixture()}
  end

  def fixture(:withdrawal, user) do
    attrs =
      %{
        "user" => user,
        "quantity" => "120.5"
      }


    {:ok, withdrawal} = Transactions.create_withdrawal(attrs)
    withdrawal
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create withdrawal" do
    test "renders withdrawal when data is valid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.withdrawal_path(conn, :create), quantity: "120.5")
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.withdrawal_path(conn, :show, id))

      user_id = user.id

      assert %{
               "id" => id,
               "user_id" => ^user_id,
               "quantity" => "120.5",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when quantity is bigger than user balance", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.withdrawal_path(conn, :create), quantity: "1010.0")
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.withdrawal_path(conn, :create), quantity: "-120.5")
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "fetch withdrawal" do
    test "renders withdrawal when trying to access one of your own", %{conn: conn, user: user} do
      %{withdrawal: withdrawal} = create_withdrawal(user)

      conn = conn |> log_in_user(user) |> get(Routes.withdrawal_path(conn, :show, withdrawal.id))

      assert %{
        "id" => withdrawal.id,
        "quantity" => Decimal.to_string(withdrawal.quantity),
        "user_id" => user.id,
        "date" => NaiveDateTime.to_string(withdrawal.inserted_at)
      } == json_response(conn, 200)["data"]
    end

    test "renders errors when trying to access a withdrawal from another person", %{conn: conn, user: user} do
      %{withdrawal: withdrawal} = create_withdrawal(user)

      new_user = user_fixture(%{
        document: another_valid_document(),
        email: unique_user_email()
      })

      conn = conn |> log_in_user(new_user) |> get(Routes.withdrawal_path(conn, :show, withdrawal.id))

      assert json_response(conn, 403) == "Forbidden"
    end
  end

  describe "fetch users withdrawals" do
    test "renders all of the users withdrawal, in order", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.withdrawal_path(conn, :create), quantity: "20.5")

      assert first_withdrawal = json_response(conn, 201)["data"]

      conn = post(conn, Routes.withdrawal_path(conn, :create), quantity: "15.2")

      assert second_withdrawal = json_response(conn, 201)["data"]

      conn = get(conn, Routes.withdrawal_path(conn, :index))

      assert [
        second_withdrawal,
        first_withdrawal
      ] = json_response(conn, 200)["data"]
    end
  end

  defp create_withdrawal(user) do
    withdrawal = fixture(:withdrawal, user)
    %{withdrawal: withdrawal}
  end
end
