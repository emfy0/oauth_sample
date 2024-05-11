defmodule AuthApp.Entities.AccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "access_tokens" do
    field :client_id, :id
    field :user_id, :id
    field :token, :string

    timestamps()
  end

  def changeset(access_token, attrs) do
    access_token
    |> cast(attrs, [:client_id, :user_id, :token])
    |> validate_required([:client_id, :user_id, :token])
    |> unique_constraint(:token)
  end
end
