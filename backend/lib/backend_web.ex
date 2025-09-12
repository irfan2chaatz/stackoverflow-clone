defmodule BackendWeb do
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: BackendWeb.Endpoint,
        router: BackendWeb.Router,
        statics: BackendWeb.static_paths()
    end
  end

  def html do
    quote do
      use Phoenix.Component
      use Phoenix.HTML

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      import BackendWeb.ErrorHelpers
      import BackendWeb.Gettext
      alias BackendWeb.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end

  def router do
    quote do
      use Phoenix.Router, helpers: false
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:json]
      import Plug.Conn

      unquote(verified_routes())
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
