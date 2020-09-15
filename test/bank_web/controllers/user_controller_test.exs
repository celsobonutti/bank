defmodule BankWeb.UserControllerTest do
  use BankWeb.ConnCase, async: true

  import Bank.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "fetch user" do
    test "renders user when signed in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(Routes.user_path(conn, :show))

      assert %{
        "id" => user.id,
        "name" => user.name,
        "balance" => Decimal.to_float(user.balance),
        "email" => user.email
      } == json_response(conn, 200)["data"]
    end

    test "returns 401 when not signed in", %{conn: conn} do
      conn = conn |> get(Routes.user_path(conn, :show))

      assert json_response(conn, 401) == "Unauthorized"
    end
  end
end
