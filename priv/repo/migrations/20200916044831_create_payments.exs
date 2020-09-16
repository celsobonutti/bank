defmodule Bank.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :quantity, :decimal, null: false
      add :boleto_code, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:payments, [:user_id])
  end
end
