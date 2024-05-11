defmodule AuthAppWeb.ApiOauthController do
  use AuthAppWeb, :controller

  alias AuthApp.Repo

  alias AuthApp.Entities.{Authorization}

  plug :find_authorization when action in [:show]

  def show(conn, _) do
    authorization = conn.assigns.authorization

    conn
    |> json(
      %{
        user: %{
          email: authorization.user.email
        },
      }
    )
  end

  defp find_authorization(conn, _) do
    authorization = Repo.get_by(Authorization, code: conn.params["code"]) |> Repo.preload(:user)

    if authorization do
      conn
      |> assign(:authorization, authorization)
    else
      conn
      |> json(%{error_code: "invalid_code", error_message: "Invalid code"})
      |> halt()
    end
  end
end

