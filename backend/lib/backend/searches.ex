defmodule Backend.Searches do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Searches.Search

  # Insert a search query
  def create_search(attrs \\ %{}) do
    %Search{}
    |> Search.changeset(attrs)
    |> Repo.insert()
  end

  # Get last 5 searches for a user
  def last_five(user_id) do
    from(s in Search,
      where: s.user_id == ^user_id,
      order_by: [desc: s.inserted_at],
      limit: 5
    )
    |> Repo.all()
  end
end
