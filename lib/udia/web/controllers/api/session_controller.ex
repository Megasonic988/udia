defmodule Udia.Web.Api.SessionController do
  use Udia.Web, :controller
  alias Udia.Repo

  def create(conn, params) do
    case authenticate(params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_status(:created)
        |> render(Udia.Web.SessionView, "show.json", user: user, jwt: jwt, exp: exp)
      :error ->
        conn
        |> put_status(:unauthorized)
        |> render(Udia.Web.SessionView, "error.json")
    end
  end

  def delete(conn, _) do
    jwt = Guardian.Plug.current_token(conn)
    Guardian.revoke!(jwt)

    conn
    |> put_status(:ok)
    |> render(Udia.Web.SessionView, "delete.json")
  end

  def refresh(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    jwt = Guardian.Plug.current_token(conn)
    case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        {:ok, new_jwt, new_claims} = Guardian.refresh!(jwt, claims, %{ttl: {30, :days}})
        exp = Map.get(new_claims, "exp")
        conn
        |> put_status(:ok)
        |> render(Udia.Web.SessionView, "show.json", user: user, jwt: new_jwt, exp: exp)
      {:error, _reason} ->
        conn
        |> put_status(:forbidden)
        |> render(Udia.Web.SessionView, "forbidden.json", errors: ["Not Authenticated"])
    end
  end

  defp authenticate(%{"username" => username, "password" => password}) do
    if is_nil(username) do
      :error
    else
      user = Repo.get_by(Udia.Accounts.User, username: username)
      case check_password(user, password) do
        true -> {:ok, user}
        _ -> :error
      end
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end
end
