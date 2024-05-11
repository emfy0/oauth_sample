defmodule AuthAppWeb.SessionController do
  use AuthAppWeb, :controller

  alias AuthApp.Operations.Users.{Register, Login}
  alias AuthAppWeb.UserAuth

  def create(conn, %{"_action" => "register"} = params) do
    register(conn, params, "Account created successfully!")
  end

  def create(conn, params) do
    login(conn, params, "Welcome back!")
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.clear_current_user()
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: ~p"/auth/sign_in")
  end

  defp register(conn, %{"user" => user_params}, info) do
    case Register.call(user_params) do
      {:ok, session} ->
        conn =
          conn
          |> put_flash(:info, info)
          |> UserAuth.set_current_user(session.user.email, session.token)

        if conn.req_cookies["current_client_id"] do
          conn
          |> redirect(to: ~p"/oauth?client_id=#{conn.req_cookies["current_client_id"]}")
        else
          conn
          |> redirect(to: ~p"/users/me")
        end
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: ~p"/auth/sign_up")
    end
  end

  defp login(conn, %{"user" => user_params}, info) do
    case Login.call(user_params) do
      {:ok, session} ->
        conn =
          conn
          |> put_flash(:info, info)
          |> UserAuth.set_current_user(session.user.email, session.token)

        if conn.req_cookies["current_client_id"] do
          conn
          |> redirect(to: ~p"/oauth?client_id=#{conn.req_cookies["current_client_id"]}")
        else
          conn
          |> redirect(to: ~p"/users/me")
        end
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: ~p"/auth/sign_in")
    end
  end
end
