defmodule BackendWeb.GeneralController do
  use BackendWeb, :controller
  alias Backend.LLM.{PopularQuestions, Tags}

  # /api/popular_questions?sort=votes&page=1
  def questions(conn, params) do
    sort = Map.get(params, "sort", "votes")
    page = Map.get(params, "page", "1") |> safe_int()
    questions = PopularQuestions.fetch_questions(sort, page)
    json(conn, %{questions: questions})
  end

  # /api/tags?page=1
  def tags(conn, params) do
    page = Map.get(params, "page", "1") |> safe_int()
    tags = Tags.fetch_tags(page)
    json(conn, %{tags: tags})
  end

  defp safe_int(val) when is_binary(val) do
    case Integer.parse(val) do
      {num, _} -> num
      :error -> 1
    end
  end

  defp safe_int(val) when is_integer(val), do: val
  defp safe_int(_), do: 1
end
