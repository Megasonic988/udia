defmodule Udia.Logs.Comment do
  use Ecto.Schema

  schema "logs_comments" do
    field :content, :string
    field :creator, Ecto.UUID
    field :parent, Ecto.UUID
    field :post, Ecto.UUID

    timestamps()
  end
end
