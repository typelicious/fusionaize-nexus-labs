# fusionAIze Nexus Labs

Open-source, modular reference stack for a **secure agent + automation** setup.

**Core idea:** Edge (secure ingress) → Core (n8n + Moltbot) → Workers (LLM/runner) → Backups/Observability.

## Start here

- [Step 01 — Pi Edge (Headless)](docs/runbooks/step-01-pi-edge.md)

> Security note: This repository is a template. **Never commit secrets**. Use `.env.example` files only.

## Modules (high-level)

- **nexus-edge**: secure ingress + DNS (Pi-hole), reverse proxy (Caddy), optional SSO/2FA + abuse protection
- **nexus-core**: n8n + Moltbot + Postgres + Redis queue + credentials management
- **nexus-llm-worker**: local LAN LLM (LM Studio) for cost-optimized coding/review tasks
- **nexus-backup**: backups (e.g., Synology DS212) + restore runbooks

## Repository layout

- `docs/` — runbooks, architecture, extensions
- `edge/pi/` — scripts + configs for the Pi (nexus-edge)

## License

MIT — see [LICENSE](LICENSE).
