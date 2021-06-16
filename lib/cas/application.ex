defmodule Cas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Cas.Repo,
      # Start the Telemetry supervisor
      CasWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cas.PubSub},
      # Start the Endpoint (http/https)
      CasWeb.Endpoint
      # Start a worker by calling: Cas.Worker.start_link(arg)
      # {Cas.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(:list_menus, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Cas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
