defmodule Udia.Web.Api.UserController do
  use Udia.Web, :controller

  alias Udia.Accounts
  alias Udia.Accounts.User

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %User{} = user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_status(:created)
        |> render(Udia.Web.SessionView, "show.json", user: user, jwt: jwt, exp: exp)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Udia.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
