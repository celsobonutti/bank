defmodule Bank.TransactionsTest do
  use Bank.DataCase

  alias Bank.Transactions
  alias Bank.AccountsFixtures
  alias Bank.Accounts.User

  setup do
    user = AccountsFixtures.user_fixture()

    [user: user]
  end

  describe "deposits" do
    alias Bank.Transactions.Deposit

    @valid_attrs %{"quantity" => "120.5"}
    @invalid_attrs %{
      "quantity" => "-10.0",
      "user" => %User{
        balance: Decimal.new("0.0"),
        id: 1
      }
    }

    def deposit_fixture(attrs \\ %{}) do
      {:ok, deposit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_deposit()

      deposit
    end

    test "get_deposit!/1 returns the deposit with given id", state do
      deposit = deposit_fixture(%{"user" => state[:user]})

      assert Transactions.get_deposit!(deposit.id) == deposit
    end

    test "create_deposit/1 with valid data creates a deposit", state do
      attrs =
        %{"user" => state[:user]}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Deposit{} = deposit} = Transactions.create_deposit(attrs)
      assert deposit.quantity == Decimal.new("120.5")
    end

    test "create_deposit/1 with invalid data returns error changeset" do
      assert {:error, changeset} = Transactions.create_deposit(@invalid_attrs)

      assert %{
               id: ["usuário inexistente"],
               balance: ["deve ser maior que o saldo original"]
             } = errors_on(changeset)
    end

    test "change_deposit/1 returns a deposit changeset", state do
      deposit = deposit_fixture(%{"user" => state[:user]})

      assert %Ecto.Changeset{} = Transactions.change_deposit(deposit)
    end

    test "get_user_deposits/1 returns all deposits for an user", state do
      {:ok, first_deposit} = Transactions.create_deposit(%{"user" => state[:user], "quantity" => "120.5"})
      :timer.sleep(1000)
      {:ok, second_deposit} = Transactions.create_deposit(%{"user" => state[:user], "quantity" => "240.10"})

      [d2, d1] = Transactions.get_user_deposits(state[:user].id)

      assert d1.inserted_at < d2.inserted_at
      assert d1 == first_deposit
      assert d2 == second_deposit
    end
  end
end
