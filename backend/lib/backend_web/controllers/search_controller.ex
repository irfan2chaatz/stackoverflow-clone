defmodule BackendWeb.SearchController do
  import Ecto.Query, only: [from: 2]
  alias Backend.Repo
  alias Backend.Searches.Search
  alias Backend.LLM.Fetcher
  alias Backend.LLM.Reranker

  use BackendWeb, :controller

  def index(conn, %{"q" => query}) do
    from(s in Search, where: s.query == ^query)
    |> Repo.delete_all()

    %Search{}
    |> Search.changeset(%{query: query})
    |> Repo.insert()

    Repo.query!("""
      DELETE FROM searches
      WHERE id NOT IN (
        SELECT id FROM searches
        ORDER BY inserted_at DESC
        LIMIT 5
      )
    """)

    last_searches =
      from(s in Search,
        order_by: [desc: s.inserted_at],
        limit: 5,
        select: s.query
      )
      |> Repo.all()

    answers = Fetcher.fetch_answers(query)
    reranked_answers = Reranker.rerank(query, answers)

    json(conn, %{
      result: "You searched for: #{query}",
      last_searches: last_searches,
      answers: answers,
      reranked_answers: reranked_answers
    })
  end

  # Endpoint to fetch recent searches for frontend
  def recent_searches(conn, _params) do
    recent =
      from(s in Search,
        order_by: [desc: s.inserted_at],
        limit: 5,
        select: s.query
      )
      |> Repo.all()

    json(conn, %{recent: recent})
  end
end
