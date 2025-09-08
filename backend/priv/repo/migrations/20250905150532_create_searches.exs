defmodule Backend.Repo.Migrations.CreateSearches do
  use Ecto.Migration

  def change do
    create table(:searches) do
      add :query, :text, null: false
      timestamps(type: :utc_datetime_usec)
    end

    create index(:searches, [:inserted_at])
    create unique_index(:searches, [:query])
  end
end

