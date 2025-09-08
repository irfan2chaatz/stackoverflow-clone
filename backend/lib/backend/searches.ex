defmodule Backend.Searches do
  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Searches.Search

  @max_recent 5

  def add_recent_search(query) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    from(s in Search, where: s.query == ^query)
    |> Repo.delete_all()

    {:ok, search} =
      %Search{}
      |> Search.changeset(%{query: query, inserted_at: now, updated_at: now})
      |> Repo.insert()
    prune_old_searches()

    {:ok, search}
  end

  def last_five() do
    from(s in Search,
      order_by: [desc: s.inserted_at],
      limit: @max_recent
    )
    |> Repo.all()
  end

  defp prune_old_searches do
    subquery =
      from(s in Search,
        order_by: [desc: s.inserted_at],
        offset: @max_recent
      )

    Repo.delete_all(subquery)
  end
end
