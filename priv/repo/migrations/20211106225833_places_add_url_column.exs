defmodule PlacesAlloverseCom.Repo.Migrations.PlacesAddUrlColumn do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :url, :string
    end

  end
end
