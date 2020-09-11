defmodule BankWeb.HomeController do
  use BankWeb, :controller

  def index(conn, _params) do
    path =
      if conn.assigns[:current_user] do
        "/app"
      else
        Routes.user_session_path(conn, :new)
      end

    conn
    |> redirect(to: path)
    |> halt()
  end
end
