defmodule BackendWeb.SearchController do
  use BackendWeb, :controller
  alias Backend.StackOverflow

  def index(conn, %{"q" => query}) do
    # call a function to get answers
    answers = StackOverflow.fetch_answers(query)
    json(conn, %{answers: answers})
  end
end
