defmodule Blogo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Blogo.Repo,
      # Start the Telemetry supervisor
      BlogoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Blogo.PubSub},
      # Start the Endpoint (http/https)
      BlogoWeb.Endpoint
      # Start a worker by calling: Blogo.Worker.start_link(arg)
      # {Blogo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blogo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlogoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
