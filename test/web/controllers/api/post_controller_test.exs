defmodule Udia.Web.PostControllerTest do
  use Udia.Web.ConnCase

  alias Udia.Logs
  alias Udia.Logs.Post

  @login_attrs %{username: "udia", password: "hunter2"}
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

  test "creates post and renders post when data is valid", %{conn: conn} do
    # Login
    insert_user(@login_attrs)
    conn = post conn, session_path(conn, :create), @login_attrs
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = post conn, post_path(conn, :create), @create_attrs
    assert json_response(conn, 201)
  end


  test "fails to create post and render post when data is invalid", %{conn: conn} do
    # Login
    insert_user(@login_attrs)
    conn = post conn, session_path(conn, :create), @login_attrs
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = post conn, post_path(conn, :create), @invalid_attrs
    assert %{"error" => "Post must have title and content"} == json_response(conn, 400)
  end

  test "fails to create post and render post when unauthenticated", %{conn: conn} do
    conn = post conn, post_path(conn, :create), @create_attrs
    assert %{"errors" => ["Unauthenticated"]} == json_response(conn, 401)
  end

  # test "does not create post and renders errors when data is invalid"

  # test "updates chosen post and renders post when data is valid"

  # test "does not update chosen post and renders errors when data is invalid"

  # test "deletes chosen post"
end
