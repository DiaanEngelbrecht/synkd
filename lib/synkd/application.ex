defmodule Synkd.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SynkdWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Synkd.PubSub},
      # Start the Endpoint (http/https)
      SynkdWeb.Endpoint,
      # Start our session tracking Agent
      Synkd.Sessions.SessionAgent
      # Start a worker by calling: Synkd.Worker.start_link(arg)
      # {Synkd.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Synkd.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SynkdWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
