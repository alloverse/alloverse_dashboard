defmodule PlacesAlloverseCom.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlacesAlloverseCom.Accounts.Credential
  alias PlacesAlloverseCom.Places.Place

  schema "users" do
    field :name, :string
    field :username, :string
    has_one :credential, Credential
    has_many :places, Place
    field :admin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :admin])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
