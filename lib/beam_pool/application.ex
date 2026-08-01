defmodule BeamPool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    wss_url = System.get_env("ETH_WSS_URL") || "wss://ethereum-rpc.publicnode.com"

    children = [
      {BeamPool.NodeListener, [url: wss_url, name: :primary_node]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BeamPool.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
