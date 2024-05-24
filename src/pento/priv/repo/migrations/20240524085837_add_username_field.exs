defmodule Pento.Repo.Migrations.AddUsernameField do
  use Ecto.Migration

  # super interesting read I do not implement here
  # https://github.com/fly-apps/safe-ecto-migrations
  # https://fly.io/phoenix-files/backfilling-data/
  def change do
    alter table("users") do
      add :username, :string, default: "Change My Name"
    end
  end
end
