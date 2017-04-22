defmodule Udia.Web.Api.UserController do
  use Udia.Web, :controller

  alias Udia.Accounts
  alias Udia.Accounts.User

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %User{} = user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, _claims} = Guardian.Plug.claims(new_conn)

        new_conn
        |> put_status(:created)
        |> render(Udia.Web.SessionView, "show.json", user: user, jwt: jwt)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Udia.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def me(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> render(Udia.Web.UserView, "user.json", user: user)
  end
end
