defmodule BankWeb.AppControllerTest do
  use BankWeb.ConnCase, async: true

  import Bank.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /app" do
    test "when not authenticated", %{conn: conn} do
      conn = get(conn, "/app")
      assert redirected_to(conn) == "/users/log_in"
    end

    test "when authenticated", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get("/app")
      response = html_response(conn, 200)
      assert response =~ "<div id=\"app\"></div>"
    end
  end
end
