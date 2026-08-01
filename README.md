# BEAMpool 

> High-concurrency, fault-tolerant EVM mempool threat inspector built with Elixir (BEAM) and Rust.

`BEAMpool` is an open-source pre-execution security engine designed to monitor raw transaction streams in real time across multiple Ethereum/EVM nodes. By leveraging Elixir’s actor model and Supervision Trees, it inspects unconfirmed transactions (`pending`) for DeFi exploits, Flash Loan attacks, and MEV anomalies before they are mined into a block.

---

## Key Features

* **Fault-Tolerant Ingestion:** Spawns isolated OTP processes per RPC WebSocket connection—if a node connection drops or chokes, only that child process restarts.
* **Lock-Free Deduplication:** Fast in-memory transaction deduplication using Erlang Term Storage (`ETS`).
* **Calldata & ABI Inspection:** Parses raw transaction inputs to detect high-volume loan borrows, multi-call proxies, and reentrancy execution patterns on the fly.
* **Low Latency:** Designed to process thousands of JSON-RPC events per second with minimal RAM/CPU footprint.

---

## Tech Stack

* **Language:** Elixir (BEAM VM)
* **Concurrency Model:** OTP / GenServer / Supervision Trees
* **In-Memory Store:** ETS (Erlang Term Storage)
* **Decoder (Optional):** Rust via Rustler (NIFs) for high-performance RLP/ABI parsing

---

## Roadmap

### Phase 1: Core Engine & Ingestion (MVP)
- [x] **OTP Application Setup:** Initialize Elixir project with Supervision Trees.
- [x] **Resilient WebSocket Ingestion:** Connect to EVM WSS nodes using Erlang's native `:gun` library for maximum compatibility and fault tolerance.
- [x] **Pending Mempool Stream:** Subscribe to `newPendingTransactions` via JSON-RPC over WebSocket in real time.
- [x] **Basic Supervision & Auto-Healing:** Automatic process restart on connection loss without dropping the whole application.

---

### Phase 2: In-Memory Storage & Processing Pipeline
- [ ] **Lock-Free Deduplication (`ETS`):** Implement Erlang Term Storage table to filter duplicate TX hashes across multiple node streams with near-zero latency.
- [ ] **Async Worker Pool (`Task.Supervisor`):** Spawn concurrent, isolated processes to fetch full transaction details via `eth_getTransactionByHash`.
- [ ] **Multi-Node Pooling:** Support simultaneous connections to multiple RPC providers (Alchemy, Infura, QuickNode, local Geth/Reth) for maximum coverage.

---

### Phase 3: Calldata Decoding & Threat Inspection
- [ ] **ABI & Calldata Parsing:** Extract function selectors (`bytes4`), addresses, and input parameters from raw calldata.
- [ ] **DeFi Pattern Detection:** Identify high-volume Flash Loan borrows, Sandwich attacks, and suspicious DEX swaps (Uniswap V2/V3, Curve, Balancer).
- [ ] **Rust Integration via NIFs (`Rustler`):** Offload heavy RLP encoding/decoding and ABI parsing to Rust for sub-millisecond execution.

---

### Phase 4: Alerting, Analytics & Production Readiness
- [ ] **Real-time Event Streaming:** Broadcast flagged threat transactions via WebSockets or Webhooks (Discord, Telegram, Slack).
- [ ] **Metrics & Monitoring:** Export PromEx / Telemetry metrics to Prometheus and Grafana dashboards for throughput analysis.
- [ ] **Containerization:** Docker & Docker Compose setup for quick one-click deployment.

## Quick Start

### Prerequisites

* Elixir 1.15+ / Erlang 26+
* An active WSS Ethereum Node endpoint (Alchemy, Infura, or local Geth/Reth)

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/itsVentie/beampool.git](https://github.com/itsVentie/beampool.git)
   cd beampool

```

2. **Install dependencies:**
```bash
mix deps.get

```


3. **Configure Environment:**
Create an `.env` or set your node endpoints:
```bash
export ETH_WSS_URL="wss://ethereum-rpc.publicnode.com"

```


4. **Run in interactive mode:**
```bash
iex -S mix

```



---

## License

Distributed under the MIT License.

