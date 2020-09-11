defmodule BankWeb.HomeControllerTest do
  use BankWeb.ConnCase, async: true

  import Bank.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /" do
    test "when not authenticated", %{conn: conn} do
      conn = get(conn, "/")
      assert redirected_to(conn) == "/users/log_in"
    end

    test "when authenticated", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get("/")
      assert redirected_to(conn) == "/app"
    end
  end
end
