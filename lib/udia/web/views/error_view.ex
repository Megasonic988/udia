defmodule Udia.Web.ErrorView do
  use Udia.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # Single Error as a string
  def render("error.json", %{error: error}) do
    %{error: error}
  end

  # Multiple Errors as an array of strings or a map
  def render("errors.json", %{errors: errors}) do
    %{errors: errors}
  end


  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
