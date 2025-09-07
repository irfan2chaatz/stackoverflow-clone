defmodule BackendWeb.SearchController do
  import Ecto.Query, only: [from: 2]
  alias Backend.Repo
  alias Backend.Searches.Search
  alias Backend.LLM.Fetcher
  alias Backend.LLM.Reranker

  use BackendWeb, :controller

  def index(conn, %{"q" => query}) do
    # Save the current search
    %Search{}
    |> Search.changeset(%{query: query})
    |> Repo.insert()

    # Fetch last 5 searches (descending by time)
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
end
