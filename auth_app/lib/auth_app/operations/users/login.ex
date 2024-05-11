defmodule AuthApp.Operations.Users.Login do
  alias AuthApp.Entities.User
  alias AuthApp.Repo

  alias AuthApp.Operations.Sessions.CreateNew

  def call(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)

    authenticated = case user do
      nil ->
        Bcrypt.no_user_verify()
      _ -> 
        Bcrypt.verify_pass(password, user.password_digest)
    end

    if authenticated do
      CreateNew.call(user)
    else
      {:error, "Invalid email or password."}
    end
  end
end

