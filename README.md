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

