defmodule Udia.Logs.Post do
  @moduledoc """
  The schema for the Logs.Post model.
  """

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "logs_posts" do
    field :title, :string
    field :content, :string
    belongs_to :creator, Udia.Accounts.User, type: :binary_id

    timestamps(type: :utc_datetime)
  end
end
