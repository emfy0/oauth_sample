defmodule AuthAppWeb.UsersMeLive do
  use AuthAppWeb, :live_view

  alias AuthApp.Entities.Clients
  alias AuthApp.Validators.Clients.CreateValidation

  def mount(_params, _session, socket) do
    clients = AuthApp.Repo.all(Clients)
    client_form = to_form(%{}, as: :client)

    {:ok, assign(socket, %{
      clients: clients,
      client_form: client_form
    })}
  end

  def handle_event("create_client", %{"client" => params}, socket) do
    with {:ok, params} <- CreateValidation.validate_to_changeset(:create, params),
          changeset <- Clients.changeset(%Clients{}, params),
         {:ok, _client} <- AuthApp.Repo.insert(changeset) do
      clients = AuthApp.Repo.all(Clients)

      {:noreply, assign(socket, %{
        clients: clients,
        client_form: to_form(%{}, as: :client)
      })}
    else
      {:error, changeset} ->
        {:noreply, assign(socket, :client_form, to_form(changeset, as: :client))}
    end
  end
end
