defmodule Bank.TransactionsTest.Withdrawals do
  use Bank.DataCase

  alias Bank.Transactions
  alias Bank.AccountsFixtures
  alias Bank.Accounts
  alias Bank.Accounts.User

  setup do
    user = AccountsFixtures.user_with_balance_fixture()

    [user: user]
  end


  describe "withdrawals" do
    alias Bank.Transactions.Withdrawal

    @valid_attrs %{"quantity" => "120.5"}
    @invalid_attrs %{
      "quantity" => "-10.0",
      "user" => %User{
        balance: Decimal.new("0.0"),
        id: 1
      }
    }

    def withdrawal_fixture(attrs \\ %{}) do
      {:ok, withdrawal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_withdrawal()

      withdrawal
    end

    test "get_withdrawal!/1 returns the withdrawal with given id", state do
      withdrawal = withdrawal_fixture(%{"user" => state[:user]})

      assert Transactions.get_withdrawal!(withdrawal.id) == withdrawal
    end

    test "create_withdrawal/1 with valid data creates a withdrawal", state do
      attrs =
        %{"user" => state[:user]}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Withdrawal{} = withdrawal} = Transactions.create_withdrawal(attrs)
      assert withdrawal.quantity == Decimal.new("120.5")

      %User{balance: new_balance} = Accounts.get_user!(state[:user].id)
      assert ^new_balance = Decimal.sub(state[:user].balance, withdrawal.quantity)
    end

    test "create_withdrawal/1 with a value bigger than the user balance returns error changeset",
         state do
      attrs =
        %{"user" => state[:user]}
        |> Enum.into(%{"quantity" => "1010.0"})

      assert {:error, changeset} = Transactions.create_withdrawal(attrs)

      assert %{
               balance: ["valor decrementado não pode ser maior que o saldo do usuário"]
             } = errors_on(changeset)
    end

    test "create_withdrawal/1 with invalid data returns error changeset" do
      assert {:error, changeset} = Transactions.create_withdrawal(@invalid_attrs)

      assert %{
               id: ["usuário inexistente"],
               balance: ["valor decrementado deve ser positivo"]
             } = errors_on(changeset)
    end

    test "change_withdrawal/1 returns a withdrawal changeset", state do
      withdrawal = withdrawal_fixture(%{"user" => state[:user]})

      assert %Ecto.Changeset{} = Transactions.change_withdrawal(withdrawal)
    end

    test "get_user_withdrawals/1 returns all withdrawals for an user", state do
      {:ok, first_withdrawal} =
        Transactions.create_withdrawal(%{"user" => state[:user], "quantity" => "20.5"})

      :timer.sleep(1000)

      {:ok, second_withdrawal} =
        Transactions.create_withdrawal(%{"user" => state[:user], "quantity" => "15.2"})

      [d2, d1] = Transactions.get_user_withdrawals(state[:user].id)

      assert d1.inserted_at < d2.inserted_at
      assert d1 == first_withdrawal
      assert d2 == second_withdrawal
    end
  end
end
