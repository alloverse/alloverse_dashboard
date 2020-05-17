defmodule PlacesAlloverseComWeb.Helpers.Auth do

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id, do: !!PlacesAlloverseCom.Accounts.get_user!(user_id)
  end

end
