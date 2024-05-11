defmodule AuthApp.Operations.Sessions.CreateNew do
  alias AuthApp.Entities.Session

  alias AuthApp.Repo

  def call(user) do
    Session.changeset(%Session{}, %{user: user, token: Ecto.UUID.generate()})
    |> Repo.insert()
  end
end
