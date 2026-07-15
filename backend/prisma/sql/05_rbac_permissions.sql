-- RBAC: permission catalog + role grants (source of truth for auth.permissions[])
-- Collation must match `role` (utf8mb4_0900_ai_ci).

DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS permission;

CREATE TABLE permission (
  id              CHAR(36)     NOT NULL,
  permission_key  VARCHAR(64)  NOT NULL,
  name            VARCHAR(100) NOT NULL,
  created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_permission_key (permission_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE role_permission (
  id             CHAR(36)    NOT NULL,
  role_id        CHAR(36)    NOT NULL,
  permission_id  CHAR(36)    NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_role_permission (role_id, permission_id),
  KEY idx_role_permission_permission (permission_id),
  CONSTRAINT fk_role_permission_role
    FOREIGN KEY (role_id) REFERENCES role (id),
  CONSTRAINT fk_role_permission_permission
    FOREIGN KEY (permission_id) REFERENCES permission (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
