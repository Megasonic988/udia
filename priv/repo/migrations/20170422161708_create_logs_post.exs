defmodule Udia.Repo.Migrations.CreateUdia.Logs.Post do
  use Ecto.Migration

  def change do
    create table(:logs_posts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :content, :string
      add :creator_id, references(:accounts_users, type: :uuid, on_delete: :nilify_all)

      timestamps([type: :utc_datetime])
    end

    create index(:logs_posts, [:creator_id])
  end
end
