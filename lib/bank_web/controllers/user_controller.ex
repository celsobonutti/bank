defmodule BankWeb.UserController do
  use BankWeb, :controller

  action_fallback BankWeb.FallbackController

  def show(conn, _opts) do
    render(conn, "show.json", user: conn.assigns[:current_user])
  end
end
