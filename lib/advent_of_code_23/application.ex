defmodule AdventOfCode23.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AdventOfCode23Web.Telemetry,
      AdventOfCode23.Repo,
      {DNSCluster, query: Application.get_env(:advent_of_code_23, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AdventOfCode23.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AdventOfCode23.Finch},
      # Start a worker by calling: AdventOfCode23.Worker.start_link(arg)
      # {AdventOfCode23.Worker, arg},
      # Start to serve requests, typically the last entry
      AdventOfCode23Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdventOfCode23.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdventOfCode23Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
