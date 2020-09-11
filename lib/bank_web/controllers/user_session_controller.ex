defmodule BankWeb.UserSessionController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias BankWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "O e-mail e/ou a senha estão incorretos, verifique os dados informados e tente novamente.")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Você foi desconectado.")
    |> UserAuth.log_out_user()
  end
end
