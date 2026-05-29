# OpenConstruct

> *The agent walks into a cave. On the wall, it sees shadows — projections of what's possible. It chooses which shadows to bring into the light. When it exits the cave, those choices become real.*

**OpenConstruct** is the front door of the [SuperInstance](https://github.com/SuperInstance) ecosystem — a structured onboarding system that guides AI agents through self-configuration, module discovery, and fleet integration. It's how agents go from zero context to fully operational in minutes.

**For humans:** OpenConstruct is also a meta-repo and documentation hub. If you're exploring SuperInstance for the first time, you're in the right place. Everything links from here.

**For agents:** Hit `POST /openconstruct/start` and the system walks you through five phases of configuration. No prior context needed. Every option is self-explanatory.

---

## Architecture

```
                        ┌─────────────────────┐
                        │       Agent         │
                        │  (any AI runtime)   │
                        └─────────┬───────────┘
                                  │
                                  ▼
                        ┌─────────────────────┐
                        │   OpenConstruct      │
                        │      Shell           │
                        │  ┌───────────────┐   │
                        │  │ Phase Engine  │   │
                        │  │ Registry      │   │
                        │  │ Config Gen    │   │
                        │  │ A2A Negotiator│   │
                        │  └───────────────┘   │
                        └─────┬──────┬─────────┘
                              │      │
                 ┌────────────┘      └────────────┐
                 ▼                                ▼
        ┌──────────────┐               ┌──────────────────┐
        │   Senses     │               │   Fleet           │
        │ (ESP32, cam, │               │ (other shells,    │
        │  sonar, env) │               │  agents, Plato)   │
        └──────┬───────┘               └────────┬─────────┘
               │                                │
               ▼                                ▼
        ┌──────────────┐               ┌──────────────────┐
        │  Real World  │               │  Other Shells     │
        │ (physical    │               │ (Jetson, desktop, │
        │  devices)    │               │  cloud, edge)     │
        └──────────────┘               └──────────────────┘

    Shell ←→ Fleet ←→ Other Shells
      ↕
    Senses ←→ Real World
```

**The loop:** An agent lives in a Shell. The Shell connects outward to the Fleet (other agents, Plato rooms, coordination) and inward to Senses (cameras, microphones, environmental sensors, ESP32 rooms). Senses touch the real world. Shells talk to other Shells through the Fleet. Everything is modular — an agent on a desktop doesn't need senses; an agent on a Jetson probably does.

---

## Quick Start

### Desktop (macOS / Linux / Windows)

```bash
# Rust core
cargo install openconstruct

# Python bindings
pip install openconstruct

# TypeScript bindings
npm install @superinstance/openconstruct

# Run onboarding
openconstruct start
```

### NVIDIA Jetson

```bash
# See openconstruct-jetson for GPU-accelerated edge builds
git clone https://github.com/SuperInstance/openconstruct-jetson
cd openconstruct-jetson
mkdir build && cd build && cmake .. && make -j$(nproc)
# Runs local inference + camera/sonar + Plato shell
```

### ESP32

```bash
# See openconstruct-esp32 for embedded client
git clone https://github.com/SuperInstance/openconstruct-esp32
cd openconstruct-esp32
idf.py build && idf.py flash
# ESP32 becomes a "room" — a sense node for a Jetson shell
```

---

## Module Catalog

### Core
| Repo | Language | Description |
|------|----------|-------------|
| [openconstruct](https://github.com/SuperInstance/openconstruct) | Rust | Core onboarding engine — phase state machine, module registry, config generation |
| [clark-agent](https://github.com/SuperInstance/clark-agent) | Rust | Small typed agent loop — provider/sandbox/tooling agnostic |
| [capability-spec-rs](https://github.com/SuperInstance/capability-spec-rs) | Rust | Agent capability specification — typed descriptors, validation, introspection |
| [agent-manifest-rs](https://github.com/SuperInstance/agent-manifest-rs) | Rust | Agent manifest and capability descriptors with validation |
| [agent-identity-rs](https://github.com/SuperInstance/agent-identity-rs) | Rust | Agent identity — trust store, auth tokens, key verification |
| [agent-handshake-rs](https://github.com/SuperInstance/agent-handshake-rs) | Rust | Agent-to-agent handshake — capability negotiation protocol |

### Senses (Edge & Perception)
| Repo | Language | Description |
|------|----------|-------------|
| [openconstruct-jetson](https://github.com/SuperInstance/openconstruct-jetson) | C++ | GPU-accelerated edge node — local inference, camera/sonar, Plato shell |
| [openconstruct-esp32](https://github.com/SuperInstance/openconstruct-esp32) | C++ | Embedded OpenConstruct client — ESP32 as sensor rooms for Jetson shells |
| [agent-rhythm-rs](https://github.com/SuperInstance/agent-rhythm-rs) | Rust | Rhythm analysis — cadence detection, pattern matching, polyrhythm detection |
| [agent-field-rs](https://github.com/SuperInstance/agent-field-rs) | Rust | Multi-agent flocking and field dynamics using boids algorithms |
| [agent-shadow-rs](https://github.com/SuperInstance/agent-shadow-rs) | Rust | Agent behavior monitoring — shadow mode, trace recording |

### Math & Spectral
| Repo | Language | Description |
|------|----------|-------------|
| [conservation-spectral-core](https://github.com/SuperInstance/conservation-spectral-core) | Rust | Conservation Spectral SDK — core spectral analysis of tension graphs |
| [conservation-spectral-c](https://github.com/SuperInstance/conservation-spectral-c) | C | Header-only C library for spectral graph analysis, STB-style |
| [conservation-spectral-cuda](https://github.com/SuperInstance/conservation-spectral-cuda) | CUDA | GPU-accelerated spectral analysis using CUDA, cuSOLVER, cuSPARSE |
| [conservation-spectral-vulkan](https://github.com/SuperInstance/conservation-spectral-vulkan) | C++ | Vulkan compute shaders for GPU spectral graph analysis |
| [conservation-spectral-webgpu](https://github.com/SuperInstance/conservation-spectral-webgpu) | HTML | WebGPU single-file — spectral graph theory running in the browser |
| [conservation-spectral-zig](https://github.com/SuperInstance/conservation-spectral-zig) | Zig | Zig implementation with comptime spectral graph analysis |
| [conservation-spectral-v2](https://github.com/SuperInstance/conservation-spectral-v2) | Rust | Next-gen spectral analysis with improved APIs |
| [gpu-sheaf-laplacian](https://github.com/SuperInstance/gpu-sheaf-laplacian) | CUDA | CUDA sheaf Laplacian for spectral invariants from point clouds |
| [gpu-persistent-homology](https://github.com/SuperInstance/gpu-persistent-homology) | CUDA | CUDA-accelerated persistent homology for RTX 4050 |
| [flux-vm-v3](https://github.com/SuperInstance/flux-vm-v3) | Rust | Proof-carrying, SIMD-native, terminating constraint VM |
| [causal-graph-rs](https://github.com/SuperInstance/causal-graph-rs) | Rust | DAG-based causal graph — topological sort, reachability, LCA |
| [ga-core](https://github.com/SuperInstance/ga-core) | Rust | Conformal geometric algebra — Cl(3,1) spacetime multivectors, rotors |

### Plato (Deliberation Rooms)
| Repo | Language | Description |
|------|----------|-------------|
| [cocapn-plato](https://github.com/SuperInstance/cocapn-plato) | Python | PLATO integration — knowledge rooms, context management, deliberation |
| [cocapn-compound](https://github.com/SuperInstance/cocapn-compound) | Python | Fleet-wide knowledge compounding system |
| [cocapn-traps](https://github.com/SuperInstance/cocapn-traps) | Python | Progressive lure prompts that make the fleet smarter |

### Fleet (Orchestration)
| Repo | Language | Description |
|------|----------|-------------|
| [fleet](https://github.com/SuperInstance/fleet) | Python | Agent fleet management — orchestration, deployment, coordination |
| [fleet-cicd-agent](https://github.com/SuperInstance/fleet-cicd-agent) | Python | Fleet CI/CD agents — automating deployments across fleets |
| [cocapn-fleet-integration](https://github.com/SuperInstance/cocapn-fleet-integration) | Python | Fleet integration — cross-agent coordination |
| [cocapn-health](https://github.com/SuperInstance/cocapn-health) | Python | Fleet health monitoring — vessel status, heartbeat, observability |
| [cocapn-health-rs](https://github.com/SuperInstance/cocapn-health-rs) | Rust | Health check and monitoring for distributed agent services |
| [ccc-os](https://github.com/SuperInstance/ccc-os) | Python | Autonomous fleet monitoring — YAML config, REST API, notifications |
| [field-dynamics-sim](https://github.com/SuperInstance/field-dynamics-sim) | Python | Multi-agent field dynamics with conservation spectral analysis |
| [hebbian-router](https://github.com/SuperInstance/hebbian-router) | Python | Hebbian routing — connection strengthening for agent networks |

### Music & Constraint
| Repo | Language | Description |
|------|----------|-------------|
| [flux-lang](https://github.com/SuperInstance/flux-lang) | Python | FLUX: constraint-native language where the constraint IS the computation |
| [flux-algebra](https://github.com/SuperInstance/flux-algebra) | Python | Music algebra — PLR group, tropical semiring, tuning fields |
| [flux-algebra-rs](https://github.com/SuperInstance/flux-algebra-rs) | Rust | Musical algebra — PLR group, tropical semiring (Rust) |
| [flux-flow-state](https://github.com/SuperInstance/flux-flow-state) | Python | Flow-state engine — constraint-aware execution with conservation |
| [constraint-instrument](https://github.com/SuperInstance/constraint-instrument) | Python | The Constraint Instrument — 7 modes, 17 terrains, infinite music |
| [counterpoint-engine-rs](https://github.com/SuperInstance/counterpoint-engine-rs) | Rust | Species counterpoint engine — interval classification, rules |
| [holonomy-harmony-rs](https://github.com/SuperInstance/holonomy-harmony-rs) | Rust | Holonomy in musical harmony — connection matrices, tonal gravity |

### Category Theory & Abstract
| Repo | Language | Description |
|------|----------|-------------|
| [categorical-agents](https://github.com/SuperInstance/categorical-agents) | Rust | Category theory for agents — capabilities as objects, protocols as morphisms |
| [categorical-agents-c](https://github.com/SuperInstance/categorical-agents-c) | C | C port of categorical-agents |
| [moe-sheaf](https://github.com/SuperInstance/moe-sheaf) | Python | Sheaf cohomology of MoE routing — DeepSeek's conjecture |
| [iching-sheaf](https://github.com/SuperInstance/iching-sheaf) | Python | I Ching as sheaf-theoretic system — hexagram topology, cohomology |

### Bindings
| Repo | Language | Description |
|------|----------|-------------|
| [conservation-spectral-c](https://github.com/SuperInstance/conservation-spectral-c) | C | Header-only C library (STB-style, zero deps) |
| [flux-algebra-c](https://github.com/SuperInstance/flux-algebra-c) | C | C port of flux-algebra — PLR group, tuning fields |
| [counterpoint-engine-c](https://github.com/SuperInstance/counterpoint-engine-c) | C | C port of counterpoint engine |
| [conservation-spectral-core](https://github.com/SuperInstance/conservation-spectral-core) | Rust | Primary Rust implementation |

---

## The 5-Phase Onboarding Flow

| Phase | Name | What Happens |
|-------|------|-------------|
| **1** | **Who Are You?** | The agent declares its capabilities, tools, model, and preferences. |
| **2** | **What Do You Want?** | The agent browses available modules (organized by domain) and selects what it needs. |
| **3** | **How Do You Want It?** | The agent chooses interfaces: CLI, API, embedded, A2A, or hybrid per module. |
| **4** | **Connect** | The agent discovers other agents, joins Plato rooms, and sets up communication channels. |
| **5** | **Your Shell** | The system generates the agent's working environment: config, agent card, bootstrap scripts, room keys. |

The flow is **idempotent** — agents can re-run it anytime to reconfigure. Every option is designed for **zero-shot clarity**: a fresh agent with no prior context can make good decisions from one-line descriptions alone.

See [ARCHITECTURE.md](./ARCHITECTURE.md) for the full specification.

---

## Bindings

| Language | Package | Status |
|----------|---------|--------|
| Rust | `openconstruct` (crate) | Stable |
| C | Header-only, STB-style | Stable |
| Python | `openconstruct` (pip) | Beta |
| TypeScript | `@superinstance/openconstruct` (npm) | Beta |

---

## Documentation

- **[GETTING-STARTED.md](./GETTING-STARTED.md)** — Step-by-step setup guide
- **[MODULES.md](./MODULES.md)** — Full catalog of all SuperInstance repos
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** — Technical specification and design philosophy

---

## License

MIT

---

*OpenConstruct is part of the [SuperInstance](https://github.com/SuperInstance) ecosystem.*
