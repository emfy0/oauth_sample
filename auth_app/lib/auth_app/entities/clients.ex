defmodule AuthApp.Entities.Clients do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "clients" do
    field :name, :string
    field :callback_url, :string

    timestamps()
  end

  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :callback_url])
    |> validate_required([:name, :callback_url])
  end
end
