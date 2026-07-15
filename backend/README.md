# ROMS API (NestJS)

Phase **B0** bootstrap for FoodCanteenManagement.

- Framework: NestJS 11  
- ORM: Prisma 5 → MySQL 8 database `roms`  
- Schema DDL source of truth: [`prisma/sql/04_schema_mysql8.sql`](./prisma/sql/04_schema_mysql8.sql) (same as `docs/backend/sprint-0/04_schema_mysql8.sql`)  
- Design docs: [`docs/backend/sprint-0/`](../docs/backend/sprint-0/)

## Prerequisites

1. **Node.js 20+** (LTS)  
2. **MySQL 8.0** with database `roms` already created by running the SQL script in Workbench  
3. Your MySQL root (or app user) password

## Setup

```bash
cd backend
copy .env.example .env
# Edit .env — set DATABASE_URL password to match Workbench
```

Example `.env`:

```env
DATABASE_URL="mysql://root:YOUR_PASSWORD@localhost:3306/roms"
PORT=3000
API_PREFIX=api/v1
```

Then:

```bash
npm install
npx prisma generate
npm run start:dev
```

## Verify

| URL | Expect |
|-----|--------|
| http://localhost:3000/api/v1/health | `{ "status": "ok", ... }` with database up |
| http://localhost:3000/api/v1/restaurants/demo-restaurant | Seeded demo restaurant |
| http://localhost:3000/api/v1/restaurants/demo-restaurant/tables | 10 tables |
| http://localhost:3000/docs | Swagger UI |

## Scripts

| Command | Purpose |
|---------|---------|
| `npm run start:dev` | Hot-reload API |
| `npm run build` | Compile |
| `npx prisma generate` | Generate Prisma Client from `schema.prisma` |
| `npx prisma db pull` | Refresh Prisma models from live MySQL (optional) |
| `npx prisma studio` | Browse data UI |

**Do not** run `prisma migrate` against this DB unless you intentionally switch DDL ownership from the SQL script to Prisma migrations. Schema was applied via Workbench SQL.

## What’s next (roadmap)

| Phase | Work |
|-------|------|
| B1 | Staff auth (JWT + refresh) |
| B2 | Tables + stable QR join |
| B3 | Cart / batch / kitchen |
| A5 | Flutter UseCase purification (parallel) |
| B5 | Flutter remote adapters (after A5) |

## Flutter note

The Flutter app still uses in-memory data. This API does not change Flutter until Phase B5.
