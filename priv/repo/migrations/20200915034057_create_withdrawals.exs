defmodule Bank.Repo.Migrations.CreateWithdrawals do
  use Ecto.Migration

  def change do
    create table(:withdrawals) do
      add :quantity, :decimal
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:withdrawals, [:user_id])
  end
end
