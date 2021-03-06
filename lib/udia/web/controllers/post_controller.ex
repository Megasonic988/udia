defmodule Udia.Web.PostController do
  use Udia.Web, :controller

  import Ecto.Query
  alias Udia.Logs
  alias Udia.Logs.Post

  plug Guardian.Plug.EnsureAuthenticated, [handler: Udia.Web.SessionController] when action in [:create, :update, :delete]

  action_fallback Udia.Web.FallbackController

  def index(conn, params) do
    page =
      Post
      |> order_by(desc: :inserted_at)
      |> Udia.Repo.paginate(params)
    posts = page.entries
      |> Udia.Repo.preload(:author)
    render(conn, "index.json", posts: posts, pagination: Udia.PaginationHelpers.pagination(page))
  end

  def create(conn, post_params) do
    cur_user = Guardian.Plug.current_resource(conn)
    case Logs.create_post(cur_user, post_params) do
      {:ok, post_versioned} ->
        post = Map.get(post_versioned, :model)
        post = Udia.Repo.preload(post, :author)

        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Udia.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Logs.get_post!(id)
    post = Udia.Repo.preload(post, :author)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Logs.get_post!(id)
    post = Udia.Repo.preload(post, :author)

    cur_user = Guardian.Plug.current_resource(conn)

    if cur_user.id != post.author_id do
      conn
      |> put_status(:forbidden)
      |> render(Udia.Web.SessionView, "forbidden.json", error: "Invalid user")
    else
      case Logs.update_post(cur_user, post, post_params) do
        {:ok, post_versioned} ->
          post = Map.get(post_versioned, :model)

          conn
          |> put_status(:accepted)
          |> render("show.json", post: post)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Udia.Web.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    cur_user = Guardian.Plug.current_resource(conn)
    post = Logs.get_post!(id)

    if cur_user.id != post.author_id do
      conn
      |> put_status(:forbidden)
      |> render(Udia.Web.SessionView, "forbidden.json", error: "Invalid user")
    else
      Logs.delete_post(post)
      send_resp(conn, :no_content, "")      
    end
  end
end
