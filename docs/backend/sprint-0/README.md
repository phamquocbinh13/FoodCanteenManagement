# Architecture Sprint 0 — Backend Foundation (Design Only)

**Status:** Awaiting human review  
**Constraint:** No Flutter code changes. No backend implementation yet.

## Deliverables

| # | Document | Description |
|---|----------|-------------|
| 1 | [01_BACKEND_ARCHITECTURE.md](./01_BACKEND_ARCHITECTURE.md) | Stack, auth, realtime, deployment, scalability |
| 2 | [02_API_CONTRACT.md](./02_API_CONTRACT.md) | REST + WS contracts mapped from repositories/use cases |
| 3 | [03_DATABASE_DESIGN.md](./03_DATABASE_DESIGN.md) | Entity→table map, integrity, indexes |
| 4 | [04_schema_mysql8.sql](./04_schema_mysql8.sql) | MySQL 8.0 CE Workbench-ready script |
| 5 | [05_RISK_ANALYSIS.md](./05_RISK_ANALYSIS.md) | Risks, mitigations, open questions |
| 6 | [06_BACKEND_IMPLEMENTATION_ROADMAP.md](./06_BACKEND_IMPLEMENTATION_ROADMAP.md) | Phased build plan after approval |

## Source of truth used

- `PROJECT_CONTEXT.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`
- `DATA_MODEL.md`
- `MEMORY.md`
- Flutter `lib/domain/**`, `lib/application/usecases/**`, repositories, OrderingStore

## Guiding principle

```
Flutter Entity → MySQL Table → Backend Repository → REST/WS → Flutter Remote Repository Adapter
```

- Domain **repository interfaces** are already backend-ready.  
- Application **UseCases** still need **Phase A5** (dependency purification) before drop-in remote wiring.  
- Session create: documented transition from client-generated metadata → server-authoritative (API §3.0).

## Human approval gate

Backend coding may begin only after explicit approval of these documents (especially schema + API contract). Phase A5 may start in parallel with B0 once approved.
