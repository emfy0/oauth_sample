defmodule AuthApp.Repo.Migrations.CreateInitialSchema do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_digest, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:sessions) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :token, :string

      timestamps()
    end

    create unique_index(:sessions, [:token])

    create table(:clients, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :callback_url, :string

      timestamps()
    end

    create table(:authorizations) do
      add :client_id, references(:clients, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :code, :string

      timestamps()
    end

    create unique_index(:authorizations, [:code])

    create table(:access_tokens) do
      add :client_id, references(:clients, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :session_id, references(:sessions, on_delete: :delete_all)
      add :valid_until, :utc_datetime
      add :token, :string

      timestamps()
    end

    create unique_index(:access_tokens, [:token])
  end
end
