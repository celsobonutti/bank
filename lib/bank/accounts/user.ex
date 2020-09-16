defmodule Bank.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Accounts
  alias Bank.Boleto

  @derive {Inspect, except: [:password]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :document, :string
    field :balance, :decimal, default: Decimal.new("0.00")
    field :boleto_code, :string, virtual: true
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both e-mail and password.
  Otherwise databases may truncate the e-mail without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :document, :name])
    |> validate_document()
    |> validate_email()
    |> validate_password()
    |> validate_required([:name], message: "não pode estar em branco")
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email], message: "não pode estar em branco")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "formato inválido")
    |> validate_length(:email, max: 160, message: "deve possuir no máximo 160 caracteres")
    |> unsafe_validate_unique(:email, Bank.Repo, message: "já existe uma conta com este e-mail")
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password], message: "não pode estar em branco")
    |> validate_length(:password, min: 12, message: "deve possuir ao menos 12 caracteres")
    |> validate_length(:password, max: 80, message: "deve possuir no máximo 80 caracteres")
    |> validate_format(:password, ~r/[a-z]/,
      message: "deve possuir ao menos um caracter minúsculo"
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "deve possuir ao menos um caracter maiúsculo"
    )
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "deve possuir ao menos um número ou caracter especial"
    )
    |> prepare_changes(&hash_password/1)
  end

  defp validate_document(changeset) do
    changeset
    |> validate_required([:document], message: "não pode estar em branco")
    |> validate_format(:document, ~r/[0-9]{11}/, message: "documento inválido")
    |> validate_document_format()
    |> unsafe_validate_unique(:document, Bank.Repo,
      message: "já existe uma conta com este documento"
    )
    |> unique_constraint(:document)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
  A user changeset for changing the e-mail.

  It requires the e-mail to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "não foi alterado")
    end
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "senhas não conferem")
    |> validate_password()
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  An user changeset for increasing balance
  """
  def balance_increase_changeset(user, quantity) do
    user
    |> change(%{
      balance: Decimal.add(user.balance, Decimal.new(quantity))
    })
    |> validate_number(:balance,
      greater_than: user.balance,
      message: "valor incrementado deve ser positivo"
    )
    |> validate_current_user_id()
  end

  @doc """
  An user changeset for decreasing balance
  """
  def balance_decrease_changeset(user, quantity) do
    user
    |> change(%{
      balance: Decimal.sub(user.balance, Decimal.new(quantity))
    })
    |> validate_number(:balance,
      less_than: user.balance,
      message: "valor decrementado deve ser positivo"
    )
    |> validate_number(:balance,
      greater_than_or_equal_to: 0,
      message: "valor decrementado não pode ser maior que o saldo do usuário"
    )
    |> validate_current_user_id()
  end

  def boleto_payment_changeset(user, boleto_code) do
    user
    |> change(%{boleto_code: boleto_code})
    |> validate_boleto(user)
    |> validate_number(:balance,
      greater_than_or_equal_to: 0,
      message: "valor do boleto excede o saldo do usuário"
    )
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Bank.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "senha inválida")
    end
  end

  @doc """
  Validates if the user_id in the changeset exists in the DB.
  """
  def validate_current_user_id(changeset) do
    if get_field(changeset, :id) |> Accounts.user_exists?() do
      changeset
    else
      add_error(changeset, :id, "usuário inexistente")
    end
  end

  defp validate_document_format(changeset) do
    if changeset.valid? do
      document_is_valid =
        with document <- get_field(changeset, :document),
             {starting_digits, [first_verification, second_verification]} <-
               get_document_digits(document),
             digits_are_valid <-
               are_digits_valid?(starting_digits, first_verification, second_verification),
             do: digits_are_valid && not is_repetition?(document)

      if document_is_valid do
        changeset
      else
        add_error(changeset, :document, "documento inválido")
      end
    else
      changeset
    end
  end

  defp get_document_digits(document) do
    document
    |> String.graphemes()
    |> Enum.map(fn digit -> String.to_integer(digit) end)
    |> Enum.split(9)
  end

  defp are_digits_valid?(starting_digits, first_verification, second_verification) do
    first_sum = calculate_digit_sum(starting_digits)
    second_sum = calculate_digit_sum(starting_digits ++ [first_verification])

    case {first_sum, second_sum} do
      {^first_verification, ^second_verification} ->
        true

      _ ->
        false
    end
  end

  defp calculate_digit_sum(digits) do
    sum =
      digits
      |> Enum.with_index()
      |> Enum.reduce(0, fn {number, index}, acc ->
        acc + number * (length(digits) + 1 - index)
      end)

    case rem(sum * 10, 11) do
      10 -> 0
      any -> any
    end
  end

  defp is_repetition?(digits) do
    character_list =
      digits
      |> String.graphemes()
      |> Enum.uniq()

    length(character_list) == 1
  end

  defp validate_boleto(changeset, user) do
    if changeset.valid? do
      case Boleto.parse(get_field(changeset, :boleto_code)) do
        {:ok, boleto} ->
          if Boleto.still_payable?(boleto) do
            put_change(changeset, :balance, Decimal.sub(user.balance, boleto.value))
          else
            add_error(changeset, :boleto_code, "boleto vencido")
          end

        {:error, reason} ->
          add_error(changeset, :boleto_code, reason)
      end
    else
      changeset
    end
  end
end
