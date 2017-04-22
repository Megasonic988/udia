defmodule Udia.Accounts.User do
  @moduledoc """
  The schema for the Accounts.User model.
  """

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "accounts_users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps([type: :utc_datetime])
  end
end
