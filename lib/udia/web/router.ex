defmodule Udia.Web.Router do
  use Udia.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", Udia.Web.Api do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create]
  end

  scope "/api", Udia.Web.Api do
    pipe_through [:api, :auth]
  end

  scope "/", Udia.Web do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
