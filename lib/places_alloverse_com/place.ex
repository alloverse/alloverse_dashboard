defmodule PlacesAlloverseCom.Places.Place do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlacesAlloverseCom.Accounts.User

  schema "places" do
    field :description, :string
    field :name, :string
    field :public, :boolean, default: false
    field :recommended, :boolean, default: false
    belongs_to :user, User
    field :url, :string
    field :image_url, :string

    timestamps()
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:name, :description, :public, :recommended, :url, :image_url])
    |> validate_required([:name, :description, :public])
  end
end
