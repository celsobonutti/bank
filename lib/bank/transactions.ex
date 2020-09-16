defmodule Bank.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Transactions.Deposit
  alias Bank.Transactions.Withdrawal
  alias Bank.Transactions.Payment
  alias Bank.Accounts.User

  @doc """
  Returns the list of deposits.

  ## Examples

      iex> list_deposits()
      [%Deposit{}, ...]

  """
  def list_deposits do
    Repo.all(Deposit)
  end

  @doc """
  Gets a single deposit.

  Raises `Ecto.NoResultsError` if the Deposit does not exist.

  ## Examples

      iex> get_deposit!(123)
      %Deposit{}

      iex> get_deposit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deposit!(id), do: Repo.get!(Deposit, id)

  @doc """
  Creates a deposit.

  ## Examples

      iex> create_deposit(%{field: value})
      {:ok, %Deposit{}}

      iex> create_deposit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deposit(%{"quantity" => quantity, "user" => user}) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.balance_increase_changeset(user, quantity))
    |> Ecto.Multi.insert(
      :deposit,
      Deposit.changeset(%Deposit{}, %{quantity: quantity, user_id: user.id})
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{deposit: deposit}} -> {:ok, deposit}
      {:error, :user, changeset, _} -> {:error, changeset}
      {:error, :deposit, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deposit changes.

  ## Examples

      iex> change_deposit(deposit)
      %Ecto.Changeset{data: %Deposit{}}

  """
  def change_deposit(%Deposit{} = deposit, attrs \\ %{}) do
    Deposit.changeset(deposit, attrs)
  end

  @doc """
  Gets the list of an user's deposit.

  ## Example

    iex> get_user_deposits(user_id)
    {:ok, list(%Deposit{})}

    iex> get_user_deposits(user_id)
    {:ok, []}
  """
  def get_user_deposits(user_id) do
    query = from d in Deposit, where: d.user_id == ^user_id, order_by: [desc: :inserted_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of withdrawals.

  ## Examples

      iex> list_withdrawals()
      [%Withdrawal{}, ...]

  """
  def list_withdrawals do
    Repo.all(Withdrawal)
  end

  @doc """
  Gets a single withdrawal.

  Raises `Ecto.NoResultsError` if the Withdrawal does not exist.

  ## Examples

      iex> get_withdrawal!(123)
      %Withdrawal{}

      iex> get_withdrawal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_withdrawal!(id), do: Repo.get!(Withdrawal, id)

  @doc """
  Creates a withdrawal.

  ## Examples

      iex> create_withdrawal(%{field: value})
      {:ok, %Withdrawal{}}

      iex> create_withdrawal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_withdrawal(%{"quantity" => quantity, "user" => user}) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.balance_decrease_changeset(user, quantity))
    |> Ecto.Multi.insert(
      :withdrawal,
      Withdrawal.changeset(%Withdrawal{}, %{quantity: quantity, user_id: user.id})
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{withdrawal: withdrawal}} -> {:ok, withdrawal}
      {:error, :user, changeset, _} -> {:error, changeset}
      {:error, :withdrawal, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking withdrawal changes.

  ## Examples

      iex> change_withdrawal(withdrawal)
      %Ecto.Changeset{data: %Withdrawal{}}

  """
  def change_withdrawal(%Withdrawal{} = withdrawal, attrs \\ %{}) do
    Withdrawal.changeset(withdrawal, attrs)
  end

  @doc """
  Gets the list of an user's withdrawals.

  ## Example

    iex> get_user_withdrawals(user_id)
    {:ok, list(%Withdrawal{})}

    iex> get_user_withdrawals(user_id)
    {:ok, []}
  """
  def get_user_withdrawals(user_id) do
    query = from w in Withdrawal, where: w.user_id == ^user_id, order_by: [desc: :inserted_at]
    Repo.all(query)
  end

  alias Bank.Transactions.Payment

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment)
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(%{"boleto_code" => boleto_code, "user" => user}) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.boleto_payment_changeset(user, boleto_code))
    |> Ecto.Multi.insert(
      :payment,
      Payment.changeset(%Payment{}, %{boleto_code: boleto_code, user_id: user.id})
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{payment: payment}} -> {:ok, payment}
      {:error, :user, changeset, _} -> {:error, changeset}
      {:error, :payment, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{data: %Payment{}}

  """
  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end

  @doc """
  Gets the list of an user's payments.

  ## Example

    iex> get_user_payments(user_id)
    {:ok, list(%Payment{})}

    iex> get_user_payments(user_id)
    {:ok, []}
  """
  def get_user_payments(user_id) do
    query = from p in Payment, where: p.user_id == ^user_id, order_by: [desc: :inserted_at]
    Repo.all(query)
  end
end
