---
name: setup-relay
description: Guides configuration and deployment of an edge relay (Cloudflare Workers) to securely bridge external webhooks and messaging platforms (LINE, Telegram, Slack, Teams) to the local agent workspace.
---

# Setup Edge Relay Skill

This skill assists users in deploying and configuring a secure edge relay (e.g. on Cloudflare Workers) to route remote messaging webhooks into their local desktop agent environment without exposing insecure firewall ports.

## Prerequisites
- Server running locally.
- `wrangler` CLI installed (`npm install -g wrangler`) and authenticated (`wrangler login`).
- Cloudflare account with a valid `workers.dev` subdomain.

## Configuration Steps

### 1. Edge Relay Deployment
Deploy the edge relay script via wrangler:
```bash
wrangler deploy
```
Capture the resulting production URL (`https://<relay-name>.<subdomain>.workers.dev`).

### 2. Secret & Token Generation
Generate a cryptographically secure shared authentication token:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
wrangler secret put RELAY_TOKEN
```
Configure matching `RELAY_TOKEN` and `RELAY_URL` in the local `.env` file.

### 3. Messaging Platform Integration
Configure webhook secrets for desired platforms:
- **LINE**: `LINE_CHANNEL_SECRET`, `LINE_CHANNEL_ACCESS_TOKEN`
- **Telegram**: `TELEGRAM_BOT_TOKEN`
- **Slack / Teams**: Webhook signing secret and app credentials.

### 4. Health & Egress Verification
Test the `/health` endpoint to ensure the relay acknowledges connected channels and securely tunnels payloads to the local agent listener.
