defmodule BankWeb.UserRegistrationController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Bank.Accounts.User
  alias BankWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    %{
      "document" => masked_document
    } = user_params

    document = masked_document |> String.replace(~r/(\.|-)+/, "")

    params =
      %{"document" => document}
      |> Enum.into(user_params)

    case Accounts.register_user(params) do
      {:ok, user} ->

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
