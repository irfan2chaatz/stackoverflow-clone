defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", BackendWeb do
    pipe_through(:api)

    get("/search", SearchController, :index)
    get("/recent_searches", SearchController, :recent_searches)
    get("/popular_questions", GeneralController, :questions)
    get("/tags", GeneralController, :tags)
  end
end
