defmodule BankWeb.DepositControllerTest do
  use BankWeb.ConnCase

  alias Bank.Transactions

  import Bank.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  def fixture(:deposit, user) do
    attrs =
      %{
        "user" => user,
        "quantity" => "120.5"
      }


    {:ok, deposit} = Transactions.create_deposit(attrs)
    deposit
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create deposit" do
    test "renders deposit when data is valid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.deposit_path(conn, :create), quantity: "120.5")
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.deposit_path(conn, :show, id))

      user_id = user.id

      assert %{
               "id" => id,
               "user_id" => ^user_id,
               "quantity" => "120.5",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.deposit_path(conn, :create), quantity: "-120.5")
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "fetch deposit" do
    test "renders deposit when trying to access one of your own", %{conn: conn, user: user} do
      %{deposit: deposit} = create_deposit(user)

      conn = conn |> log_in_user(user) |> get(Routes.deposit_path(conn, :show, deposit.id))

      assert %{
        "id" => deposit.id,
        "quantity" => Decimal.to_string(deposit.quantity),
        "user_id" => user.id,
        "date" => NaiveDateTime.to_string(deposit.inserted_at)
      } == json_response(conn, 200)["data"]
    end

    test "renders errors when trying to access a deposit from another person", %{conn: conn, user: user} do
      %{deposit: deposit} = create_deposit(user)

      new_user = user_fixture(%{
        document: another_valid_document(),
        email: unique_user_email()
      })

      conn = conn |> log_in_user(new_user) |> get(Routes.deposit_path(conn, :show, deposit.id))

      assert json_response(conn, 403) == "Forbidden"
    end
  end

  describe "fetch users deposits" do
    test "renders all of the users deposit, in order", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> post(Routes.deposit_path(conn, :create), quantity: "120.5")

      assert first_deposit = json_response(conn, 201)["data"]

      conn = post(conn, Routes.deposit_path(conn, :create), quantity: "240.10")

      assert second_deposit = json_response(conn, 201)["data"]

      conn = get(conn, Routes.deposit_path(conn, :index))

      assert [
        second_deposit,
        first_deposit
      ] = json_response(conn, 200)["data"]
    end
  end

  defp create_deposit(user) do
    deposit = fixture(:deposit, user)
    %{deposit: deposit}
  end
end
