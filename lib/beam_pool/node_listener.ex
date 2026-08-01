defmodule BeamPool.NodeListener do
  @moduledoc """
  Connects to the EVM-node via WebSocket through the Erlang library Gun.
  """
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(opts) do
    url = Keyword.fetch!(opts, :url)
    uri = URI.parse(url)

    host = String.to_charlist(uri.host)
    port = uri.port || 443

    Logger.info("🔌 Connecting to WebSocket: #{host}:#{port}...")

    {:ok, conn} = :gun.open(host, port, %{protocols: [:http], tls_opts: [{:verify, :verify_none}]})

    {:ok, %{conn: conn, path: uri.path || "/", stream: nil}}
  end

  @impl true
  def handle_info({:gun_up, conn, :http}, state) do
    Logger.info("HTTP connection established. Upgrading to WebSocket...")
    stream = :gun.ws_upgrade(conn, state.path)
    {:noreply, %{state | stream: stream}}
  end

  @impl true
  def handle_info({:gun_upgrade, conn, _stream, ["websocket"], _headers}, state) do
    Logger.info("WebSocket upgraded! Subscribing to mempool...")

    payload = Jason.encode!(%{
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "eth_subscribe",
      "params" => ["newPendingTransactions"]
    })

    :gun.ws_send(conn, state.stream, {:text, payload})
    {:noreply, state}
  end

  @impl true
  def handle_info({:gun_ws, _conn, _stream, {:text, msg}}, state) do
    case Jason.decode(msg) do
      {:ok, %{"method" => "eth_subscription", "params" => %{"result" => tx_hash}}} ->
        Logger.info("New TX in mempool: #{tx_hash}")

      {:ok, %{"id" => 1, "result" => sub_id}} ->
        Logger.info("Successful subscription. Sub ID: #{sub_id}")

      _ ->
        :ok
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:gun_down, _conn, _proto, _reason, _killed}, state) do
    Logger.warning("WebSocket connection dropped. Gun is auto-reconnecting...")
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.debug("Received info: #{inspect(msg)}")
    {:noreply, state}
  end
end
