defmodule AuthApp.Entities.Authorization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:client_id, :binary_id, autogenerate: true}

  schema "authorizations" do
    belongs_to :user, AuthApp.Entities.User
    field :code, :string

    timestamps()
  end

  def changeset(authorization, attrs) do
    authorization
    |> cast(attrs, [:client_id, :user_id, :code])
    |> validate_required([:client_id, :user_id, :code])
    |> unique_constraint(:code)
  end
end
