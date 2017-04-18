defmodule Udia.Web.UserControllerTest do
  use Udia.Web.ConnCase

  @create_attrs %{email: "test@udia.ca", password: "hunter2", username: "udia"}
  @create_emailless_attrs %{password: "hunter2", username: "udia"}
  @nil_attrs %{email: nil, password_hash: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    response = json_response(conn, 201)

    assert Map.has_key?(response, "token")
  end

  test "creates user and renders user when data is valid (no email)", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_emailless_attrs
    response = json_response(conn, 201)

    assert Map.has_key?(response, "token")
  end

  test "does not create user if username is taken", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    _ = json_response(conn, 201)

    new_conn = post conn, user_path(conn, :create), user: @create_attrs
    response = json_response(new_conn, 422)
    assert %{"username" => ["has already been taken"]} == response["errors"]
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @nil_attrs
    assert json_response(conn, 422)["errors"] == %{"username" => ["can't be blank"]}
  end
end
