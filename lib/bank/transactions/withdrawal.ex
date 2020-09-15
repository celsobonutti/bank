defmodule Bank.Transactions.Withdrawal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "withdrawals" do
    field :quantity, :decimal
    field :user_id, :id, null: false

    timestamps()
  end

  @doc false
  def changeset(withdrawal, attrs) do
    withdrawal
    |> cast(attrs, [:quantity, :user_id])
    |> validate_required([:quantity, :user_id])
    |> validate_number(:quantity, greater_than: 0)
  end
end
