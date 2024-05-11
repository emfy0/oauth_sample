defmodule AuthAppWeb.UserAuth do
  use AuthAppWeb, :verified_routes

  import Plug.Conn

  def on_mount(:ensure_not_authenticated, _params, session, socket) do
    socket = mount_current_user(socket, session)

    if socket.assigns.current_user do
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You are already logged in.")
        |> Phoenix.LiveView.redirect(to: ~p"/users/me")

      {:halt, socket}
    else
      {:cont, socket}
    end
  end

  def on_mount(:ensure_current_user, _params, session, socket) do
    socket = mount_current_user(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/auth/sign_in")

      {:halt, socket}
    end
  end

  def on_mount(:mount_current_user, _params,  session, socket) do
    {:cont, mount_current_user(socket, session)}
  end

  def mount_current_user(socket, session) do
    Phoenix.Component.assign_new(
      socket, :current_user, fn -> sign_in_user(session["user_token"]) end
    )
  end

  def fetch_current_user(conn, _opts) do
    user =
      get_session(conn, :user_token)
      |> sign_in_user()

    assign(conn, :current_user, user)
  end

  def sign_in_user(token) when is_nil(token), do: nil
  def sign_in_user(token) do
    case AuthApp.Operations.Sessions.FindUserByToken.call(token) do
      {:ok, user} ->
        user
      {:error, _} ->
        nil
    end
  end

  def set_current_user(conn, user_login, user_token) do
    conn
    |> put_session(:user_token, user_token)
    |> put_session(:user_login, user_login)
  end

  def clear_current_user(conn) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      AuthAppWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
