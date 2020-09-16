defmodule Bank.TransactionsTest.Payments do
  use Bank.DataCase

  alias Bank.Transactions
  alias Bank.Transactions.Payment

  alias Bank.AccountsFixtures
  alias Bank.Accounts
  alias Bank.Accounts.User

  setup do
    user = AccountsFixtures.user_with_balance_fixture()

    [user: user]
  end

  describe "payments" do

    @moduledoc """
    Boleto payment tests.
    "Working" case is disabled since the boleto can expire. Please update it before running tests.
    """
    # @valid_boleto "23793.38128 60039.354695 59000.063301 7 83810000020000"
    # @another_valid_boleto "07790.00116 44000.000511 00586.806655 7 83800000060000"
    @valid_expired_boleto "23793.38128 60030.557163 65000.063308 4 83080000058584"
    @invalid_boleto "23793.38128 60030.557163 65000.063308 3 83080000058584"

    # def payment_fixture(attrs \\ %{}) do
    #   {:ok, payment} =
    #     attrs
    #     |> Enum.into(%{
    #       "boleto_code" => @valid_boleto
    #     })
    #     |> Transactions.create_payment()

    #   payment
    # end

    # test "get_payment!/1 returns the payment with given id", state do
    #   payment = payment_fixture(%{"user" => state[:user]})
    #   assert Transactions.get_payment!(payment.id) == payment
    # end

    # test "create_payment/1 with valid data creates a payment", state do
    #   attrs = %{
    #     "boleto_code" => @valid_boleto,
    #     "user" => state[:user]
    #   }

    #   assert {:ok, %Payment{} = payment} = Transactions.create_payment(attrs)
    #   assert payment.boleto_code == @valid_boleto
    #   assert Decimal.equal?(payment.quantity, "200.0")

    #   user = Accounts.get_user!(state[:user].id)

    #   assert Decimal.eq?(user.balance, Decimal.sub(state[:user].balance, "200.0"))
    # end

    # test "create_payment/1 with repeated data returns error changeset", state do
    #   attrs = %{
    #     "boleto_code" => @valid_boleto,
    #     "user" => state[:user]
    #   }

    #   Transactions.create_payment(attrs)

    #   assert {:error, changeset = %Ecto.Changeset{}} = Transactions.create_payment(attrs)

    #   assert [
    #     boleto_code: {
    #       "este boleto já foi pago",
    #       [{:validation, :unsafe_unique}, {:fields, [:boleto_code]}]
    #     }
    #   ] = changeset.errors
    # end

    # test "get_user_payments/1 returns all withdrawals for an user", state do
    #   {:ok, first_payment} =
    #     Transactions.create_payment(%{"user" => state[:user], "boleto_code" => @valid_boleto})

    #   :timer.sleep(1000)

    #   {:ok, second_payment} =
    #     Transactions.create_payment(%{"user" => state[:user], "boleto_code" => @another_valid_boleto})

    #   [d2, d1] = Transactions.get_user_payments(state[:user].id)

    #   assert d1.inserted_at < d2.inserted_at
    #   assert d1 == first_payment
    #   assert d2 == second_payment
    # end

    test "create_payment/1 with expired boleto returns error changeset", state do
      user =
        state[:user]
        |> User.balance_decrease_changeset("1000")
        |> Bank.Repo.update!()

      attrs = %{
        "boleto_code" => @valid_expired_boleto,
        "user" => user
      }

      assert {:error, changeset = %Ecto.Changeset{}} = Transactions.create_payment(attrs)

      assert [
               boleto_code: {
                 "boleto vencido",
                 []
               }
             ] = changeset.errors
    end

    test "create_payment/1 with invalid data returns error changeset", state do
      attrs = %{
        "boleto_code" => @invalid_boleto,
        "user" => state[:user]
      }

      assert {:error, changeset = %Ecto.Changeset{}} = Transactions.create_payment(attrs)

      assert [
               boleto_code: {
                 "erro na validação de módulo 11",
                 []
               }
             ] = changeset.errors
    end

    # test "change_payment/1 returns a payment changeset", state do
    #   payment = payment_fixture(%{"user" => state[:user]})
    #   assert %Ecto.Changeset{} = Transactions.change_payment(payment)
    # end
  end
end
