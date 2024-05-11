defmodule BaseAppWeb.PageController do
  use BaseAppWeb, :controller

  @oauth_url "http://localhost:4000/api/oauth"
  @oauth_login_url "http://localhost:4000/oauth?client_id=b801dddb-e391-4e13-b53b-4e739e3e2061"

  def home(conn, %{"code" => code}) do
    conn
    |> set_user(code)
    |> render(:home)
  end

  def home(conn, _) do
    user = get_session(conn, :current_user)

    if user do
      conn
      |> assign(:user, user)
      |> render(:home)
    else
      conn
      |> redirect(external: @oauth_login_url)
    end
  end

  defp set_user(conn, code) do
    resp = Req.get!(@oauth_url <> "?code=" <> code)
  
    unless resp.body["error_code"] do
      user = resp.body["user"]

      conn
      |> assign(:user, user)
      |> put_session(:current_user, user)
    else
      conn
      |> put_flash(:error, "Invalid code")
      |> redirect(to: "/")
    end
  end
end
