defmodule Udia.Web.SessionView do
  use Udia.Web, :view

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      user: render_one(user, Udia.Web.UserView, "user.json"),
      token: jwt
    }
  end

  def render("delete.json", _) do
    %{ok: true}
  end
end
