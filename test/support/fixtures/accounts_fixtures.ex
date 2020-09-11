defmodule Bank.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bank.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hug3Passw0rd"
  def valid_user_document, do: "06038847502"
  def another_valid_document, do: "22331305617"


  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password(),
        document: valid_user_document()
      })
      |> Bank.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
