defmodule Udia.Web.Api.PostController do
  use Udia.Web, :controller

  alias Udia.Logs
  alias Udia.Logs.Post

  def index(conn, _params) do
    posts = Logs.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Logs.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Logs.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Logs.get_post!(id)

    with {:ok, %Post{} = post} <- Logs.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Logs.get_post!(id)
    with {:ok, %Post{}} <- Logs.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
