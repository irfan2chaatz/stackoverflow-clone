defmodule Backend.Searches do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Searches.Search

  @max_recent 5

  # Insert a search query, ensuring no duplicates and keeping only 5
  def add_recent_search(query) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    # 1. Delete existing duplicate if exists
    from(s in Search, where: s.query == ^query)
    |> Repo.delete_all()

    # 2. Insert new record
    {:ok, search} =
      %Search{}
      |> Search.changeset(%{query: query, inserted_at: now, updated_at: now})
      |> Repo.insert()

    # 3. Keep only last @max_recent
    prune_old_searches()

    {:ok, search}
  end

  # Get last 5 searches (no user filtering for now)
  def last_five() do
    from(s in Search,
      order_by: [desc: s.inserted_at],
      limit: @max_recent
    )
    |> Repo.all()
  end

  # Remove older searches beyond @max_recent
  defp prune_old_searches do
    subquery =
      from(s in Search,
        order_by: [desc: s.inserted_at],
        offset: @max_recent
      )

    Repo.delete_all(subquery)
  end
end
