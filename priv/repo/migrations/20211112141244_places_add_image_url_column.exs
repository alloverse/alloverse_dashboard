defmodule PlacesAlloverseCom.Repo.Migrations.PlacesAddImageUrlColumn do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :image_url, :string
    end

  end
end
