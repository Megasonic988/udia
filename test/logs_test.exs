defmodule Udia.LogsTest do
  use Udia.DataCase

  alias Udia.Logs
  alias Udia.Logs.Post

  @create_attrs %{content: "some content", title: "some title"}

  test "get_post/1 with valid data returns a post" do
    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    assert %Post{} = post = Logs.get_post!(post.id)

    assert post.id
    assert post.title == "some title"
    assert post.content == "some content"
    assert post.creator_id == user.id

    # verify user is loaded on content 'get'
    assert post.creator.username == user.username
  end

  test "create_post/2 with valid data returns a post" do
    user = insert_user(username: "udia")
    assert {:ok, %Post{} = post} = Logs.create_post(user, @create_attrs)

    assert post.id
    assert post.title == "some title"
    assert post.content == "some content"
    assert post.creator_id == user.id
  end
end
