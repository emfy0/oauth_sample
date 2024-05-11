defmodule AuthApp.Entities.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_digest, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_digest])
    |> validate_required([:email, :password_digest])
    |> unique_constraint(:email)
  end
end
