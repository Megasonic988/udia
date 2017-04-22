"""
defmodule Udia.Web.PostControllerTest do
  use Udia.Web.ConnCase

  alias Udia.Logs
  alias Udia.Logs.Post

  @create_attrs %{content: "some content", creator: "7488a646-e31f-11e4-aace-600308960662", title: "some title", type: "some type"}
  @update_attrs %{content: "some updated content", creator: "7488a646-e31f-11e4-aace-600308960668", title: "some updated title", type: "some updated type"}
  @invalid_attrs %{content: nil, creator: nil, title: nil, type: nil}

  def fixture(:post) do
    {:ok, post} = Logs.create_post(@create_attrs)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates post and renders post when data is valid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, post_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "content" => "some content",
      "creator" => "7488a646-e31f-11e4-aace-600308960662",
      "title" => "some title",
      "type" => "some type"}
  end

  test "does not create post and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen post and renders post when data is valid", %{conn: conn} do
    %Post{id: id} = post = fixture(:post)
    conn = put conn, post_path(conn, :update, post), post: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, post_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "content" => "some updated content",
      "creator" => "7488a646-e31f-11e4-aace-600308960668",
      "title" => "some updated title",
      "type" => "some updated type"}
  end

  test "does not update chosen post and renders errors when data is invalid", %{conn: conn} do
    post = fixture(:post)
    conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen post", %{conn: conn} do
    post = fixture(:post)
    conn = delete conn, post_path(conn, :delete, post)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, post)
    end
  end
end
"""
