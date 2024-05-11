defmodule AuthApp.Entities.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    belongs_to :user, AuthApp.Entities.User
    field :token, :string

    timestamps()
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:token])
    |> put_assoc(:user, attrs[:user])
    |> validate_required([:token, :user])
    |> unique_constraint(:token)
  end
end
