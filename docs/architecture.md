# fusionAIze Nexus Labs — Architecture

fusionAIze Nexus Labs is a modular reference stack for running a secure, self-hosted **agent + automation** environment.

The architecture is organized around **roles** (what a node does), not specific hardware (what a node is).
Any role can run on many types of hosts (Raspberry Pi, mini PC, VM, VPS, cloud).

## Design principles

- **Least privilege**: split ingress, orchestration, execution, and storage.
- **Deny-by-default**: only the edge is exposed; core stays private.
- **Secrets never in Git**: use env templates + a secret store.
- **Modular**: supports on-prem, private cloud, public cloud, and hybrid deployments.
- **Observable & recoverable**: metrics/logs + backups + restore runbooks.

## Roles (hardware-agnostic)

### 1) nexus-edge (ingress + optional LAN DNS)

Responsibilities:
- TLS termination + reverse proxy (Caddy/Traefik/Nginx)
- optional LAN DNS / ad-blocking (Pi-hole / AdGuard Home)
- optional SSO/2FA gate (Authelia/Authentik)
- optional abuse protection (CrowdSec)
- firewall baseline

Typical exposure:
- 80/443 (ingress)
- 53 (DNS, LAN-only if enabled)
- 22 (SSH, LAN-only)

### 2) nexus-core (orchestrator + state)

Responsibilities:
- n8n (automation backbone)
- Moltbot (agent orchestrator / dispatcher)
- Postgres (state)
- Redis (queue between webhooks and actions)
- credentials management

Typical exposure:
- ideally **not** exposed directly; accessed via `nexus-edge` reverse proxy

### 3) nexus-llm-worker (LLM execution backend)

Responsibilities:
- local model serving (LM Studio / Ollama / vLLM) and/or routing to cloud LLMs
- access restricted to LAN/VPN and allowlisted callers (e.g., `nexus-core`)
- cost-optimized coding/review tasks and offline/low-cost inference

Typical exposure:
- LAN/VPN only (HTTP API)

### 4) nexus-backup (backup target)

Responsibilities:
- backup target for configs, DB dumps, and artifacts
- retention policies + optional immutability (WORM) and offsite replication
- regular restore tests

Targets can be:
- NAS, external disk, S3-compatible object storage, rsync target, etc.

## Execution model (recommended)

- Webhooks enter via **nexus-edge**
- Workflows run in **n8n** on **nexus-core**
- Actions execute via isolated runners (future): shell/browser/CI tasks
- Moltbot enforces project policies: budgets, allowed tools/repos, approval gates
- Everything is logged and backed up

## Roadmap modules (extensions)

- SSO/2FA (Authelia/Authentik) before n8n
- CrowdSec bouncers integrated with reverse proxy
- Redis-backed queue mode and worker runners
- Observability stack (Prometheus + Grafana + Loki)
- RAG per project (Qdrant/pgvector)
- GitOps deployment workflows

## Example deployment (home lab)

This is one possible mapping (your current setup), not a requirement:

- Raspberry Pi: runs `nexus-edge` (Pi-hole + Caddy)
- Mini PC / Apple Silicon / VM: runs `nexus-core` (n8n + Moltbot + Postgres + Redis)
- Laptop/Server: runs `nexus-llm-worker` (LM Studio)
- NAS/Object Storage: runs `nexus-backup` (Synology / S3)
