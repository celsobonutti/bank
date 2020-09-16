defmodule Bank.Transactions.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Boleto

  schema "payments" do
    field :boleto_code, :string, null: false
    field :quantity, :decimal, null: false
    field :user_id, :id, null: false

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:boleto_code, :user_id])
    |> validate_required([:boleto_code, :user_id])
    |> validate_boleto()
  end

  defp validate_boleto(changeset) do
    if changeset.valid? do
      case Boleto.parse(get_field(changeset, :boleto_code)) do
        {:ok, boleto} ->
          if Boleto.still_payable?(boleto) do
            put_change(changeset, :quantity, boleto.value)
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
