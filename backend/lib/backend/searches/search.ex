defmodule Backend.Searches.Search do
  use Ecto.Schema
  import Ecto.Changeset

  schema "searches" do
    field :query, :string
    timestamps()
  end

  def changeset(search, attrs) do
    search
    |> cast(attrs, [:query])
    |> validate_required([:query])
  end
end
