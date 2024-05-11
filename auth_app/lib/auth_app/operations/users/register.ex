defmodule AuthApp.Operations.Users.Register do
  alias AuthApp.Entities.User

  alias AuthApp.Repo
  alias AuthApp.Operations.Sessions.CreateNew

  def call(%{"email" => email, "password" => password}) do
    user = User.changeset(%User{}, %{email: email, password_digest: Bcrypt.hash_pwd_salt(password)})

    Repo.transaction(fn ->
      with {:ok, user} <- Repo.insert(user),
        {:ok, session} <- CreateNew.call(user)
      do
        session
      else
        {:error, _} -> Repo.rollback("Current email is already in use.")
      end
    end)
  end
end

