defmodule BaseApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BaseAppWeb.Telemetry,
      # Start the Ecto repository
      BaseApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BaseApp.PubSub},
      # Start Finch
      {Finch, name: BaseApp.Finch},
      # Start the Endpoint (http/https)
      BaseAppWeb.Endpoint
      # Start a worker by calling: BaseApp.Worker.start_link(arg)
      # {BaseApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BaseApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BaseAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
