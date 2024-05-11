defmodule AuthAppWeb.OauthController do
  use AuthAppWeb, :controller

  alias AuthAppWeb.UserAuth
  alias AuthApp.Repo

  alias AuthApp.Entities.{Clients, Authorization}

  plug :memoize_current_client_id
  plug :authenticate_user when action in [:show, :create_authorization]
  plug :find_client when action in [:show, :create_authorization]

  def show(conn, _) do
    current_user = conn.assigns.current_user
    client = conn.assigns.client

    authorization = find_authorization(client.id, current_user.id)

    if authorization do
      conn
      |> redirect(external: client.callback_url <> "?code=#{authorization.code}")
    else
      conn
      |> put_flash(:info, "Authorize access to #{client.name}")
      |> render(:show, client: client)
    end
  end

  def create_authorization(conn, _) do
    current_user = conn.assigns.current_user
    client = conn.assigns.client

    authorization =
      %Authorization{}
      |> Authorization.changeset(%{client_id: client.id, user_id: current_user.id, code: Ecto.UUID.generate()})
      |> Repo.insert!()

    conn
    |> redirect(external: client.callback_url <> "?code=#{authorization.code}")
  end

  defp memoize_current_client_id(conn, _) do
    conn
    |> put_resp_cookie("current_client_id", conn.params["client_id"])
  end

  defp authenticate_user(conn, _) do
    conn = UserAuth.fetch_current_user(conn, %{})

    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: ~p"/auth/sign_in")
      |> halt()
    end
  end

  defp find_client(conn, _) do
    client = Repo.get_by(Clients, id: conn.params["client_id"])

    if client do
      conn
      |> assign(:client, client)
    else
      conn
      |> put_flash(:error, "Client not found.")
      |> redirect(to: ~p"/users/me")
      |> halt()
    end
  end

  def find_authorization(client_id, user_id) do
    Repo.get_by(Authorization, client_id: client_id, user_id: user_id)
  end
end
