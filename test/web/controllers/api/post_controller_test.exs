defmodule Udia.Web.PostControllerTest do
  use Udia.Web.ConnCase

  alias Udia.Logs
  alias Udia.Logs.Post

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []

    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == [
      %{
        "id" => post.id,
        "title" => "some title",
        "content" => "some content",
        "creator" => %{
          "id" => user.id,
          "email" => nil,
          "username" => "udia"
        }
      }
    ]
  end

  # test "creates post and renders post when data is valid"

  # test "does not create post and renders errors when data is invalid"

  # test "updates chosen post and renders post when data is valid"

  # test "does not update chosen post and renders errors when data is invalid"

  # test "deletes chosen post"
end
