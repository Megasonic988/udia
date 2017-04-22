defmodule Udia.AccountsTest do
  use Udia.DataCase

  alias Udia.Accounts
  alias Udia.Accounts.User

  @create_attrs %{email: "test@udia.ca", password: "hunter2", username: "udia"}
  @invalid_attrs %{email: nil, password_hash: nil, username: nil}

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
    assert user.email == "test@udia.ca"
    assert user.password_hash
    assert user.username == "udia"
    assert Map.has_key?(user, :inserted_at)
    assert Map.has_key?(user, :updated_at)
    assert Map.has_key?(user, :id)
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "get_user/1 with valid data returns a user" do
    user = insert_user(username: "udia", email: "test@udia.ca")
    assert user.id
    assert user.username == "udia"
    assert user.email == "test@udia.ca"
  end
end
