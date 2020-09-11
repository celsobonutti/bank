defmodule BankWeb.UserRegistrationControllerTest do
  use BankWeb.ConnCase, async: true

  import Bank.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1 class=\"auth__header\">Cadastro</h1>"
      assert response =~ "<label class=\"auth__label\" for=\"user_document\">CPF</label>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/app"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => email, "document" => valid_user_document(), "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/app"

      conn = get(conn, "/app")
      assert response = html_response(conn, 200)
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "document" => "494812448",  "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Cadastro"
      assert response =~ "formato inválido"
      assert response =~ "documento inválido"
    end
  end
end
