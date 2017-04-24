defmodule Udia.Repo.Migrations.CreateUdia.Logs.Comment do
  use Ecto.Migration

  def change do
    create table(:logs_comments) do
      add :content, :string
      add :creator, :uuid
      add :post, :uuid
      add :parent, :uuid

      timestamps()
    end

  end
end
