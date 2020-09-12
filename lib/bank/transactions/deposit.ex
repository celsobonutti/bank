defmodule Bank.Transactions.Deposit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deposits" do
    field :quantity, :decimal
    field :user_id, :id, null: false

    timestamps()
  end

  @doc false
  def changeset(deposit, attrs) do
    deposit
    |> cast(attrs, [:quantity, :user_id])
    |> validate_required([:quantity, :user_id])
    |> validate_number(:quantity, greater_than: 0)
  end
end
