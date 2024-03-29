defmodule PlacesAlloverseComWeb.PlaceController do
  use PlacesAlloverseComWeb, :controller

  alias PlacesAlloverseCom.Places
  alias PlacesAlloverseCom.Places.Place
  alias PlacesAlloverseCom.Accounts


  def index(conn, _params) do

    recommended_places = Places.list_recommended_places()

    public_places = Places.list_public_places()

    my_places = case Map.fetch(conn.assigns, :current_user ) do
      {:ok, nil} -> []
      {:ok, current_user} -> Places.list_my_places(current_user)
    end

    admin_user = case Map.fetch(conn.assigns, :current_user) do
      {:ok, nil} -> []
      {:ok, current_user} -> current_user.admin

    end

    render(conn, "index.html", recommended_places: recommended_places, public_places: public_places, my_places: my_places, admin_user: admin_user)
  end

  def show(conn, %{"id" => id}) do
    place = Places.get_place!(id)
    url = place.url
    image_url = place.image_url
    render(conn, "show.html", place: place, url: url, image_url: image_url)
  end

  def new(conn, _params) do
    changeset = Places.change_place(%Place{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"place" => place_params}) do

    my_places = case Map.fetch(conn.assigns, :current_user ) do
      :error -> []
      {:ok, current_user} -> Places.list_my_places(current_user)
    end

    if length(my_places) >= 5 do
      IO.puts "Maximum number of places reached."
      conn
      |> put_flash(:info, "You can't create more than 5 places, sorry.")
      |> redirect(to: Routes.place_path(conn, :index))
    else
      case Places.create_place(conn.assigns.current_user, place_params) do
        {:ok, place} ->
          conn
          |> put_flash(:info, "Place created successfully.")
          |> redirect(to: Routes.place_path(conn, :show, place))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    place = Places.get_place!(id)

    changeset = Places.change_place(place)
    render(conn, "edit.html", place: place, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do

    my_places = case Map.fetch(conn.assigns, :current_user ) do
      :error -> []
      {:ok, current_user} -> Places.list_my_places(current_user)
    end

    my_place_ids = Enum.map(my_places, fn my_place -> my_place.id end)

    place = Places.get_place!(id)

    if Enum.member?(my_place_ids, String.to_integer(id)) do
      {:ok, _place} = Places.delete_place(place)

      conn
      |> put_flash(:info, "Place deleted successfully.")
      |> redirect(to: Routes.place_path(conn, :index))
    else
      conn
      |> put_flash(:info, "You can only delete a places you own.")
      |> redirect(to: Routes.place_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "place" => place_params}) do

    my_places = case Map.fetch(conn.assigns, :current_user ) do
      :error -> []
      {:ok, current_user} -> Places.list_my_places(current_user)
    end

    my_place_ids = Enum.map(my_places, fn my_place -> my_place.id end)
    place = Places.get_place!(id)

    if Enum.member?(my_place_ids, String.to_integer(id)) do
      case Places.update_place(place, place_params) do
        {:ok, place} ->
          conn
          |> put_flash(:info, "Place updated successfully.")
          |> redirect(to: Routes.place_path(conn, :show, place))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", place: place, changeset: changeset)
      end
    else
      conn
      |> put_flash(:info, "You can only edit places you own.")
      |> redirect(to: Routes.place_path(conn, :index))
    end
  end
end
