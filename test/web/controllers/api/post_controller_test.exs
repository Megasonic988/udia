defmodule Udia.Web.PostControllerTest do
  use Udia.Web.ConnCase

  @login_attrs %{username: "udia", password: "hunter2"}
  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    # Empty array on no posts
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []

    # Add one post
    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    # Array with one post
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
    user = insert_user(@login_attrs)
    conn = post conn, session_path(conn, :create), @login_attrs
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = post conn, post_path(conn, :create), @create_attrs
    assert json_response(conn, 201)
    post_id = json_response(conn, 201)["data"]["id"]

    assert json_response(conn, 201)["data"] == %{
      "id" => post_id,
      "title" => "some title",
      "content" => "some content",
      "creator" => %{
        "id" => user.id,
        "email" => nil,
        "username" => "udia"
      }
    }
  end


  test "does not create post, renders errors when data is invalid", %{conn: conn} do
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

  test "does not create post, renders errors when unauthenticated", %{conn: conn} do
    conn = post conn, post_path(conn, :create), @create_attrs
    assert %{"errors" => ["Unauthenticated"]} == json_response(conn, 401)
  end

  test "updates chosen post and renders post when data is valid", %{conn: conn} do
    # Login
    user = insert_user(@login_attrs)
    conn = post conn, session_path(conn, :create), @login_attrs
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]

    post = insert_post(user, @create_attrs)

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = put conn, post_path(conn, :update, post.id), post: @update_attrs
    assert json_response(conn, 200)["data"] == %{
      "id" => post.id,
      "title" => "some updated title",
      "content" => "some updated content",
      "creator" => %{
        "id" => user.id,
        "email" => nil,
        "username" => "udia"
      }
    }
  end

  test "does not update chosen post, renders errors when data is invalid", %{conn: conn} do
    # Login
    user = insert_user(@login_attrs)
    conn = post conn, session_path(conn, :create), @login_attrs
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]

    post = insert_post(user, @create_attrs)

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = put conn, post_path(conn, :update, post.id), post: @invalid_attrs
    assert %{"error" => "Post must have title and content"} == json_response(conn, 400)
  end

  test "does not update post, renders errors when user mismatch", %{conn: conn} do
    user = insert_user(@login_attrs)
    post = insert_post(user, @create_attrs)

    # Login
    hacker_credentials = %{"username": "dangerdan", "password": "hunter2"}
    insert_user(hacker_credentials)
    conn = post conn, session_path(conn, :create), hacker_credentials
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = put conn, post_path(conn, :update, post.id), post: @update_attrs
    assert %{"error" => "User does not match post creator."} == json_response(conn, 403)
  end


  test "does not update post, renders errors when unauthenticated", %{conn: conn} do
    user = insert_user(@login_attrs)
    post = insert_post(user, @create_attrs)

    conn = put conn, post_path(conn, :update, post.id), post: @update_attrs
    assert %{"errors" => ["Unauthenticated"]} == json_response(conn, 401)
  end

  test "deletes chosen post", %{conn: conn} do
    # Login
    user = insert_user(@login_attrs)
    conn = post conn, session_path(conn, :create), @login_attrs
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]
    
    post = insert_post(user, @create_attrs)

    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = delete conn, post_path(conn, :delete, post.id)
    assert response(conn, 204) == ""
  end

  test "does not delete chosen post, renders errors when user mismatch", %{conn: conn} do
    user = insert_user(@login_attrs)
    post = insert_post(user, @create_attrs)

    # Login
    hacker_credentials = %{"username": "dangerdan", "password": "hunter2"}
    insert_user(hacker_credentials)
    conn = post conn, session_path(conn, :create), hacker_credentials
    assert json_response(conn, 201)
    jwt = json_response(conn, 201)["token"]
    
    conn = build_conn()
    |> put_req_header("authorization", "Bearer: #{jwt}")
    conn = delete conn, post_path(conn, :delete, post.id)
    assert %{"error" => "User does not match post creator."} == json_response(conn, 403)
  end

  test "does not delete post, renders errors when unauthenticated", %{conn: conn} do
    user = insert_user(@login_attrs)
    post = insert_post(user, @create_attrs)

    conn = delete conn, post_path(conn, :delete, post.id)
    assert %{"errors" => ["Unauthenticated"]} == json_response(conn, 401)
  end
end
