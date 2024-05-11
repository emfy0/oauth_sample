defmodule AuthApp.Operations.Sessions.FindUserByToken do
  alias AuthApp.Entities.Session
  alias AuthApp.Repo

  def call(token) do
    session = Repo.get_by(Session, [token: token]) |> Repo.preload(:user)

    if session do
      {:ok, session.user}
    else
      {:error, :not_found}
    end
  end
end
