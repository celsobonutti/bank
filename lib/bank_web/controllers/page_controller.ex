defmodule BankWeb.PageController do
  use BankWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
