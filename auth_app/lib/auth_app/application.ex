defmodule AuthApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AuthAppWeb.Telemetry,
      # Start the Ecto repository
      AuthApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AuthApp.PubSub},
      # Start Finch
      {Finch, name: AuthApp.Finch},
      # Start the Endpoint (http/https)
      AuthAppWeb.Endpoint
      # Start a worker by calling: AuthApp.Worker.start_link(arg)
      # {AuthApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
