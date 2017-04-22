defmodule Udia.LogsTest do
  use Udia.DataCase

  alias Udia.Logs
  alias Udia.Logs.Post

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  test "list_posts/0 returns a list of posts" do
    assert Logs.list_posts == []

    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    assert Logs.list_posts == [post]
  end

  test "get_post!/1 with valid data returns a post" do
    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    assert %Post{} = post = Logs.get_post!(post.id)

    assert post.id
    assert post.title == "some title"
    assert post.content == "some content"
    assert post.creator_id == user.id

    # verify user is loaded on content 'get'
    assert post.creator.username == "udia"
  end

  test "get_post!/1 with invalid data returns an error" do
    assert_raise Ecto.Query.CastError, fn -> Logs.get_post!("") end
    assert_raise Ecto.Query.CastError, fn -> Logs.get_post!(0) end
    assert_raise ArgumentError, fn -> Logs.get_post!(nil) end

    # use the user's binary_id to break Posts query
    user = insert_user(username: "udia")
    assert_raise Ecto.NoResultsError, fn -> Logs.get_post!(user.id) end
  end

  test "create_post/2 with valid data returns a post" do
    user = insert_user(username: "udia")
    assert {:ok, %Post{} = post} = Logs.create_post(user, @create_attrs)

    assert post.id
    assert post.title == "some title"
    assert post.content == "some content"
    assert post.creator_id == user.id

    # users are not preloaded on create_post
    post = post |> Udia.Repo.preload(:creator)
    assert post.creator.username == user.username
  end

  test "create_post/2 with invalid data returns errors" do
    user = insert_user(username: "udia")
    assert {:error, _} = Logs.create_post(user, @invalid_attrs)
  end

  test "update_post/2 with valid data updates a post" do
    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    assert {:ok, %Post{} = updated_post} = Logs.update_post(post, @update_attrs)
    assert updated_post.id == post.id
    assert updated_post.title == "some updated title"
    assert updated_post.content == "some updated content"
  end

  test "update_post/2 with invalid data returns errors" do
    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    assert {:error, _} = Logs.update_post(post, @invalid_attrs)
  end

  test "delete_post!/1 with a valid key deletes the post" do
    user = insert_user(username: "udia")
    post = insert_post(user, @create_attrs)

    assert %Post{} = post = Logs.get_post!(post.id)
    Logs.delete_post(post)
    assert_raise Ecto.NoResultsError, fn -> Logs.get_post!(post.id) end
  end
end
