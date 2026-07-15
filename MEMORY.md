# ROMS Iteration Memory

## Iteration: 2026-07-15 — Backend B0 bootstrap

### What changed

- Installed **Node.js LTS** on the machine (was missing).
- Created NestJS API at `backend/` (Phase B0):
  - Prisma 5 + MySQL `roms`
  - Config, Swagger (`/docs`), health (`/api/v1/health`)
  - Smoke endpoints: restaurant + tables
  - SQL copy at `backend/prisma/sql/04_schema_mysql8.sql`
  - `.env.example` + README
- Build succeeds (`npm run build`). Runtime DB ping needs real MySQL password in `.env`.

### Why

DB schema ready in Workbench; start server code so Flutter can later talk to a real API.

### How to run (human)

1. Edit `backend/.env` → set `DATABASE_URL` password to match Workbench.  
2. `cd backend && npx prisma generate && npm run start:dev`  
3. Open `http://localhost:3000/api/v1/health` and `/docs`.

### Remaining

- B1 auth, B2 QR/session, B3 kitchen…  
- Phase A5 Flutter UseCase purification before B5 remote wiring.  
- Flutter still in-memory (unchanged).

### Suggested next

Set `.env` password → verify health → implement **B1 Auth**.

---

## Prior: Sprint 0 design + corrections

See `docs/backend/sprint-0/`. Schema includes payment summary + force-close CHECKs. Phase A5 documented.
