defmodule Udia.Web.SessionView do
  use Udia.Web, :view

  def render("show.json", %{jwt: jwt}) do
    %{token: jwt}
  end

  def render("error.json", _) do
    %{error: "Invalid username or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
