defmodule Udia.Web.Api.PostController do
  use Udia.Web, :controller

  alias Udia.Logs
  alias Udia.Logs.Post

  def index(conn, _params) do
    posts = Logs.list_posts()
    render(conn, Udia.Web.PostView, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %Post{} = post} <- Logs.create_post(user, post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render(Udia.Web.PostView, "show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Logs.get_post!(id)
    render(conn, Udia.Web.PostView, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    post = Logs.get_post!(id)

    if post.creator.id == user.id do
      with {:ok, %Post{} = post} <- Logs.update_post(post, post_params) do
        render(conn, Udia.Web.PostView, "show.json", post: post)
      end
    else
      {:error, "User does not match post creator."}
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    post = Logs.get_post!(id)

    if post.creator.id == user.id do
      with {:ok, %Post{}} <- Logs.delete_post(post) do
        send_resp(conn, :no_content, "")
      end
    else
      {:error, "User does not match post creator."}
    end
  end
end
