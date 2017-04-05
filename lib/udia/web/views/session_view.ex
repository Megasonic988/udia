defmodule Udia.Web.SessionView do
  use Udia.Web, :view

  def render("show.json", %{user: user, jwt: jwt, exp: exp}) do
    %{
      data: render_one(user, Udia.Web.UserView, "user.json"),
      meta: %{token: jwt, exp: exp}
    }
  end

  def render("error.json", _) do
    %{errors: ["Invalid username or password"]}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{errors: errors}) do
    %{errors: errors}
  end
end
