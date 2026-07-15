-- =============================================================================
-- ROMS (FoodCanteenManagement) — MySQL 8.0 CE Schema
-- Architecture Sprint 0 — Design deliverable (copy-paste ready)
-- Compatible with: MySQL Workbench 8.x / MySQL Server 8.0 Community
-- Charset: utf8mb4 / Collation: utf8mb4_0900_ai_ci
-- Money: BIGINT minor units (matches Flutter Money.amountMinor)
-- IDs: CHAR(36) UUID strings (matches Flutter entity ids)
-- =============================================================================

SET NAMES utf8mb4;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE DATABASE IF NOT EXISTS roms
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE roms;

SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- Drop in reverse dependency order (idempotent re-run for Workbench)
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS v_kitchen_batch_queue;
DROP TABLE IF EXISTS domain_outbox;
DROP TABLE IF EXISTS idempotency_record;
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS staff_refresh_token;
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS staff_user;
DROP TABLE IF EXISTS session_bill_line;
DROP TABLE IF EXISTS session_payment;
DROP TABLE IF EXISTS order_payment;
DROP TABLE IF EXISTS delivery_detail;
DROP TABLE IF EXISTS order_line;
DROP TABLE IF EXISTS roms_order;
DROP TABLE IF EXISTS menu_item_availability_history;
DROP TABLE IF EXISTS customization_option;
DROP TABLE IF EXISTS customization_group;
DROP TABLE IF EXISTS menu_item;
DROP TABLE IF EXISTS menu_category;
DROP TABLE IF EXISTS batch_item_status_history;
DROP TABLE IF EXISTS batch_item_customization;
DROP TABLE IF EXISTS batch_item;
DROP TABLE IF EXISTS kitchen_batch;
DROP TABLE IF EXISTS staff_request;
DROP TABLE IF EXISTS session_timeline_event;
DROP TABLE IF EXISTS session_cart_item;
DROP TABLE IF EXISTS session_cart;
DROP TABLE IF EXISTS session_device;
DROP TABLE IF EXISTS session_auth_token;
DROP TABLE IF EXISTS dine_in_session;
DROP TABLE IF EXISTS table_qr_token;
DROP TABLE IF EXISTS restaurant_table;
DROP TABLE IF EXISTS restaurant_daily_counter;
DROP TABLE IF EXISTS restaurant_settings;
DROP TABLE IF EXISTS restaurant;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- TENANT
-- =============================================================================

CREATE TABLE restaurant (
  id            CHAR(36)     NOT NULL,
  name          VARCHAR(200) NOT NULL,
  slug          VARCHAR(100) NOT NULL,
  timezone      VARCHAR(64)  NOT NULL DEFAULT 'UTC',
  is_active     TINYINT(1)   NOT NULL DEFAULT 1,
  created_at    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_restaurant_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE restaurant_settings (
  id                         CHAR(36)    NOT NULL,
  restaurant_id              CHAR(36)    NOT NULL,
  default_currency           CHAR(3)     NOT NULL,
  tax_rate_bps               INT         NOT NULL DEFAULT 0,
  service_charge_bps         INT         NOT NULL DEFAULT 0,
  session_token_ttl_minutes  INT         NOT NULL DEFAULT 480,
  allow_qr_on_reserved_table TINYINT(1)  NOT NULL DEFAULT 0,
  payment_soft_lock_enabled  TINYINT(1)  NOT NULL DEFAULT 1,
  created_at                 DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at                 DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_restaurant_settings_restaurant (restaurant_id),
  CONSTRAINT fk_settings_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT chk_settings_tax CHECK (tax_rate_bps >= 0),
  CONSTRAINT chk_settings_svc CHECK (service_charge_bps >= 0),
  CONSTRAINT chk_settings_ttl CHECK (session_token_ttl_minutes > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE restaurant_daily_counter (
  id             CHAR(36)    NOT NULL,
  restaurant_id  CHAR(36)    NOT NULL,
  date_key       CHAR(8)     NOT NULL COMMENT 'YYYYMMDD in restaurant timezone',
  counter_type   VARCHAR(32) NOT NULL COMMENT 'session | order',
  current_value  BIGINT      NOT NULL DEFAULT 0,
  updated_at     DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_daily_counter (restaurant_id, date_key, counter_type),
  CONSTRAINT fk_daily_counter_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT chk_daily_counter_value CHECK (current_value >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- FLOOR
-- =============================================================================

CREATE TABLE restaurant_table (
  id             CHAR(36)    NOT NULL,
  restaurant_id  CHAR(36)    NOT NULL,
  label          VARCHAR(50) NOT NULL,
  capacity       SMALLINT    NOT NULL DEFAULT 4,
  status         VARCHAR(20) NOT NULL DEFAULT 'available',
  sort_order     INT         NOT NULL DEFAULT 0,
  is_active      TINYINT(1)  NOT NULL DEFAULT 1,
  created_at     DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at     DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_table_label (restaurant_id, label),
  KEY idx_table_restaurant_status (restaurant_id, status),
  CONSTRAINT fk_table_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT chk_table_status CHECK (status IN ('available', 'occupied', 'reserved')),
  CONSTRAINT chk_table_capacity CHECK (capacity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE table_qr_token (
  id             CHAR(36)     NOT NULL,
  restaurant_id  CHAR(36)     NOT NULL,
  table_id       CHAR(36)     NOT NULL,
  token_hash     VARCHAR(128) NOT NULL,
  is_active      TINYINT(1)   NOT NULL DEFAULT 1,
  created_at     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_qr_token_hash (token_hash),
  UNIQUE KEY uq_qr_table (table_id),
  KEY idx_qr_restaurant (restaurant_id),
  CONSTRAINT fk_qr_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_qr_table
    FOREIGN KEY (table_id) REFERENCES restaurant_table (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- STAFF AUTH
-- =============================================================================

CREATE TABLE role (
  id          CHAR(36)    NOT NULL,
  role_key    VARCHAR(32) NOT NULL,
  name        VARCHAR(50) NOT NULL,
  created_at  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_role_key (role_key),
  CONSTRAINT chk_role_key CHECK (role_key IN ('admin', 'manager', 'cashier', 'kitchen', 'shipper'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE staff_user (
  id              CHAR(36)     NOT NULL,
  restaurant_id   CHAR(36)     NOT NULL,
  email           VARCHAR(255) NOT NULL,
  display_name    VARCHAR(100) NOT NULL,
  password_hash   VARCHAR(255) NOT NULL,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  last_login_at   DATETIME(3)  NULL,
  created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_staff_email (restaurant_id, email),
  KEY idx_staff_restaurant (restaurant_id),
  CONSTRAINT fk_staff_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE user_role (
  id          CHAR(36)    NOT NULL,
  user_id     CHAR(36)    NOT NULL,
  role_id     CHAR(36)    NOT NULL,
  created_at  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_user_role (user_id, role_id),
  CONSTRAINT fk_user_role_user
    FOREIGN KEY (user_id) REFERENCES staff_user (id),
  CONSTRAINT fk_user_role_role
    FOREIGN KEY (role_id) REFERENCES role (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- RBAC permission catalog (also: prisma/sql/05_rbac_permissions.sql + npm run seed:rbac)
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

CREATE TABLE staff_refresh_token (
  id              CHAR(36)     NOT NULL,
  user_id         CHAR(36)     NOT NULL,
  restaurant_id   CHAR(36)     NOT NULL,
  token_hash      VARCHAR(128) NOT NULL,
  expires_at      DATETIME(3)  NOT NULL,
  revoked_at      DATETIME(3)  NULL,
  created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_refresh_token_hash (token_hash),
  KEY idx_refresh_user (user_id),
  CONSTRAINT fk_refresh_user
    FOREIGN KEY (user_id) REFERENCES staff_user (id),
  CONSTRAINT fk_refresh_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- DINE-IN SESSION
-- =============================================================================

CREATE TABLE dine_in_session (
  id                   CHAR(36)     NOT NULL,
  restaurant_id        CHAR(36)     NOT NULL,
  table_id             CHAR(36)     NOT NULL,
  session_number       BIGINT       NOT NULL,
  display_number       VARCHAR(32)  NOT NULL,
  status               VARCHAR(32)  NOT NULL DEFAULT 'open',
  opened_via           VARCHAR(32)  NOT NULL,
  opened_by_user_id    CHAR(36)     NULL,
  closed_by_user_id    CHAR(36)     NULL,
  payment_soft_lock    TINYINT(1)   NOT NULL DEFAULT 0,
  current_batch_number INT          NOT NULL DEFAULT 0,
  payment_status       VARCHAR(32)  NOT NULL DEFAULT 'unpaid',
  -- Running bill projection (Flutter DineInSession.paymentSummary / SessionPaymentSummary)
  payment_subtotal_minor       BIGINT NOT NULL DEFAULT 0,
  payment_discount_minor       BIGINT NOT NULL DEFAULT 0,
  payment_tax_minor            BIGINT NOT NULL DEFAULT 0,
  payment_service_charge_minor BIGINT NOT NULL DEFAULT 0,
  payment_total_minor          BIGINT NOT NULL DEFAULT 0,
  -- MySQL substitute for partial unique index: set to table_id while active, NULL when closed
  active_table_guard   CHAR(36)     NULL,
  opened_at            DATETIME(3)  NOT NULL,
  closed_at            DATETIME(3)  NULL,
  created_at           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_session_active_table (active_table_guard),
  UNIQUE KEY uq_session_display (restaurant_id, display_number),
  KEY idx_session_restaurant_status (restaurant_id, status),
  KEY idx_session_table (table_id),
  CONSTRAINT fk_session_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_session_table
    FOREIGN KEY (table_id) REFERENCES restaurant_table (id),
  CONSTRAINT fk_session_opened_by
    FOREIGN KEY (opened_by_user_id) REFERENCES staff_user (id),
  CONSTRAINT fk_session_closed_by
    FOREIGN KEY (closed_by_user_id) REFERENCES staff_user (id),
  CONSTRAINT chk_session_status CHECK (status IN ('open', 'payment_pending', 'closed')),
  CONSTRAINT chk_session_opened_via CHECK (opened_via IN ('qr_scan', 'cashier_manual')),
  CONSTRAINT chk_session_payment_status CHECK (payment_status IN ('unpaid', 'waiting_payment', 'paid')),
  CONSTRAINT chk_session_batch_num CHECK (current_batch_number >= 0),
  CONSTRAINT chk_session_payment_summary CHECK (
    payment_subtotal_minor >= 0 AND
    payment_discount_minor >= 0 AND
    payment_tax_minor >= 0 AND
    payment_service_charge_minor >= 0 AND
    payment_total_minor >= 0
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE session_auth_token (
  id           CHAR(36)     NOT NULL,
  session_id   CHAR(36)     NOT NULL,
  token_hash   VARCHAR(128) NOT NULL,
  expires_at   DATETIME(3)  NOT NULL,
  revoked_at   DATETIME(3)  NULL,
  created_at   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_session_token_hash (token_hash),
  KEY idx_session_token_session (session_id),
  CONSTRAINT fk_session_token_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE session_device (
  id                 CHAR(36)     NOT NULL,
  session_id         CHAR(36)     NOT NULL,
  device_fingerprint VARCHAR(128) NOT NULL,
  last_seen_at       DATETIME(3)  NOT NULL,
  created_at         DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_session_device (session_id, device_fingerprint),
  CONSTRAINT fk_session_device_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE session_cart (
  id          CHAR(36)    NOT NULL,
  session_id  CHAR(36)    NOT NULL,
  version     INT         NOT NULL DEFAULT 1,
  updated_at  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  created_at  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_session_cart (session_id),
  CONSTRAINT fk_cart_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id),
  CONSTRAINT chk_cart_version CHECK (version >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE session_cart_item (
  id                   CHAR(36)       NOT NULL,
  session_cart_id      CHAR(36)       NOT NULL,
  menu_item_id         CHAR(36)       NOT NULL,
  quantity             SMALLINT       NOT NULL DEFAULT 1,
  selections_json      JSON           NOT NULL,
  unit_price_minor     BIGINT         NOT NULL,
  currency_code        CHAR(3)        NOT NULL,
  created_at           DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at           DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_cart_item_cart (session_cart_id),
  CONSTRAINT fk_cart_item_cart
    FOREIGN KEY (session_cart_id) REFERENCES session_cart (id),
  CONSTRAINT chk_cart_item_qty CHECK (quantity > 0),
  CONSTRAINT chk_cart_item_price CHECK (unit_price_minor >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE session_timeline_event (
  id           CHAR(36)     NOT NULL,
  session_id   CHAR(36)     NOT NULL,
  event_type   VARCHAR(64)  NOT NULL,
  payload_json JSON         NOT NULL,
  actor_type   VARCHAR(32)  NOT NULL,
  actor_id     CHAR(36)     NULL,
  occurred_at  DATETIME(3)  NOT NULL,
  PRIMARY KEY (id),
  KEY idx_timeline_session_time (session_id, occurred_at),
  CONSTRAINT fk_timeline_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id),
  CONSTRAINT chk_timeline_actor CHECK (actor_type IN ('user', 'customer_session', 'system'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE staff_request (
  id                 CHAR(36)     NOT NULL,
  restaurant_id      CHAR(36)     NOT NULL,
  session_id         CHAR(36)     NOT NULL,
  request_type       VARCHAR(32)  NOT NULL,
  status             VARCHAR(32)  NOT NULL DEFAULT 'pending',
  note               VARCHAR(500) NULL,
  requested_at       DATETIME(3)  NOT NULL,
  handled_at         DATETIME(3)  NULL,
  handled_by_user_id CHAR(36)     NULL,
  created_at         DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_request_queue (restaurant_id, status, requested_at),
  KEY idx_request_session (session_id),
  CONSTRAINT fk_request_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_request_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id),
  CONSTRAINT fk_request_handler
    FOREIGN KEY (handled_by_user_id) REFERENCES staff_user (id),
  CONSTRAINT chk_request_type CHECK (request_type IN (
    'payment', 'staff_assistance', 'extra_water', 'extra_bowl', 'extra_spoon'
  )),
  CONSTRAINT chk_request_status CHECK (status IN ('pending', 'handled', 'cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- MENU
-- =============================================================================

CREATE TABLE menu_category (
  id             CHAR(36)     NOT NULL,
  restaurant_id  CHAR(36)     NOT NULL,
  name           VARCHAR(100) NOT NULL,
  sort_order     INT          NOT NULL DEFAULT 0,
  is_active      TINYINT(1)   NOT NULL DEFAULT 1,
  created_at     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_category_restaurant (restaurant_id, is_active, sort_order),
  CONSTRAINT fk_category_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE menu_item (
  id               CHAR(36)       NOT NULL,
  restaurant_id    CHAR(36)       NOT NULL,
  category_id      CHAR(36)       NOT NULL,
  name             VARCHAR(200)   NOT NULL,
  description      TEXT           NULL,
  base_price_minor BIGINT         NOT NULL,
  currency_code    CHAR(3)        NOT NULL,
  availability     VARCHAR(32)    NOT NULL DEFAULT 'available',
  image_url        VARCHAR(500)   NULL,
  sort_order       INT            NOT NULL DEFAULT 0,
  is_active        TINYINT(1)     NOT NULL DEFAULT 1,
  created_at       DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at       DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_menu_item_catalog (restaurant_id, availability, is_active),
  KEY idx_menu_item_category (category_id),
  CONSTRAINT fk_menu_item_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_menu_item_category
    FOREIGN KEY (category_id) REFERENCES menu_category (id),
  CONSTRAINT chk_menu_availability CHECK (availability IN ('available', 'out_of_stock')),
  CONSTRAINT chk_menu_price CHECK (base_price_minor >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- FK from cart item to menu (added after menu_item exists)
ALTER TABLE session_cart_item
  ADD CONSTRAINT fk_cart_item_menu
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id);

CREATE TABLE customization_group (
  id              CHAR(36)     NOT NULL,
  menu_item_id    CHAR(36)     NOT NULL,
  group_key       VARCHAR(64)  NOT NULL,
  name            VARCHAR(100) NOT NULL,
  selection_type  VARCHAR(32)  NOT NULL,
  is_required     TINYINT(1)   NOT NULL DEFAULT 0,
  min_selections  SMALLINT     NOT NULL DEFAULT 0,
  max_selections  SMALLINT     NOT NULL DEFAULT 1,
  sort_order      INT          NOT NULL DEFAULT 0,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_custom_group_key (menu_item_id, group_key),
  CONSTRAINT fk_custom_group_item
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id),
  CONSTRAINT chk_custom_selection_type CHECK (selection_type IN ('single_select', 'multi_select', 'boolean')),
  CONSTRAINT chk_custom_min_max CHECK (min_selections >= 0 AND max_selections >= min_selections)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE customization_option (
  id               CHAR(36)       NOT NULL,
  group_id         CHAR(36)       NOT NULL,
  option_key       VARCHAR(64)    NOT NULL,
  name             VARCHAR(100)   NOT NULL,
  kitchen_label    VARCHAR(100)   NOT NULL,
  price_delta_minor BIGINT        NOT NULL DEFAULT 0,
  currency_code    CHAR(3)        NOT NULL,
  is_default       TINYINT(1)     NOT NULL DEFAULT 0,
  sort_order       INT            NOT NULL DEFAULT 0,
  is_active        TINYINT(1)     NOT NULL DEFAULT 1,
  created_at       DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at       DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_custom_option_key (group_id, option_key),
  CONSTRAINT fk_custom_option_group
    FOREIGN KEY (group_id) REFERENCES customization_group (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE menu_item_availability_history (
  id                 CHAR(36)    NOT NULL,
  menu_item_id       CHAR(36)    NOT NULL,
  from_availability  VARCHAR(32) NOT NULL,
  to_availability    VARCHAR(32) NOT NULL,
  changed_by_user_id CHAR(36)    NOT NULL,
  occurred_at        DATETIME(3) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_menu_avail_hist (menu_item_id, occurred_at),
  CONSTRAINT fk_menu_avail_item
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id),
  CONSTRAINT fk_menu_avail_user
    FOREIGN KEY (changed_by_user_id) REFERENCES staff_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- ORDERS (takeaway / delivery only) — before batches for FK order_id
-- =============================================================================

CREATE TABLE roms_order (
  id                  CHAR(36)     NOT NULL,
  restaurant_id       CHAR(36)     NOT NULL,
  order_number        BIGINT       NOT NULL,
  order_type          VARCHAR(32)  NOT NULL,
  status              VARCHAR(32)  NOT NULL DEFAULT 'draft',
  customer_name       VARCHAR(200) NULL,
  customer_phone      VARCHAR(30)  NULL,
  notes               VARCHAR(500) NULL,
  created_by_user_id  CHAR(36)     NOT NULL,
  submitted_at        DATETIME(3)  NULL,
  completed_at        DATETIME(3)  NULL,
  created_at          DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at          DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_order_number (restaurant_id, order_number),
  KEY idx_order_type_status (restaurant_id, order_type, status),
  CONSTRAINT fk_order_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_order_creator
    FOREIGN KEY (created_by_user_id) REFERENCES staff_user (id),
  CONSTRAINT chk_order_type CHECK (order_type IN ('takeaway', 'delivery')),
  CONSTRAINT chk_order_status CHECK (status IN (
    'draft', 'submitted', 'in_progress', 'ready', 'completed', 'cancelled'
  ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE order_line (
  id                CHAR(36)    NOT NULL,
  order_id          CHAR(36)    NOT NULL,
  menu_item_id      CHAR(36)    NOT NULL,
  quantity          SMALLINT    NOT NULL DEFAULT 1,
  selections_json   JSON        NOT NULL,
  unit_price_minor  BIGINT      NOT NULL,
  currency_code     CHAR(3)     NOT NULL,
  created_at        DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at        DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_order_line_order (order_id),
  CONSTRAINT fk_order_line_order
    FOREIGN KEY (order_id) REFERENCES roms_order (id),
  CONSTRAINT fk_order_line_menu
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id),
  CONSTRAINT chk_order_line_qty CHECK (quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE delivery_detail (
  id                CHAR(36)     NOT NULL,
  order_id          CHAR(36)     NOT NULL,
  delivery_status   VARCHAR(32)  NOT NULL DEFAULT 'pending',
  delivery_address  TEXT         NOT NULL,
  delivery_notes    VARCHAR(500) NULL,
  shipper_user_id   CHAR(36)     NULL,
  ready_at          DATETIME(3)  NULL,
  claimed_at        DATETIME(3)  NULL,
  delivering_at     DATETIME(3)  NULL,
  completed_at      DATETIME(3)  NULL,
  created_at        DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at        DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_delivery_order (order_id),
  KEY idx_delivery_shipper (shipper_user_id, delivery_status),
  CONSTRAINT fk_delivery_order
    FOREIGN KEY (order_id) REFERENCES roms_order (id),
  CONSTRAINT fk_delivery_shipper
    FOREIGN KEY (shipper_user_id) REFERENCES staff_user (id),
  CONSTRAINT chk_delivery_status CHECK (delivery_status IN (
    'pending', 'ready', 'claimed', 'delivering', 'completed', 'unassigned'
  ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE order_payment (
  id                      CHAR(36)    NOT NULL,
  order_id                CHAR(36)    NOT NULL,
  payment_method          VARCHAR(32) NOT NULL,
  subtotal_minor          BIGINT      NOT NULL,
  tax_amount_minor        BIGINT      NOT NULL DEFAULT 0,
  service_charge_minor    BIGINT      NOT NULL DEFAULT 0,
  total_amount_minor      BIGINT      NOT NULL,
  currency_code           CHAR(3)     NOT NULL,
  paid_at                 DATETIME(3) NOT NULL,
  recorded_by_user_id     CHAR(36)    NOT NULL,
  created_at              DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_order_payment (order_id),
  CONSTRAINT fk_order_payment_order
    FOREIGN KEY (order_id) REFERENCES roms_order (id),
  CONSTRAINT fk_order_payment_user
    FOREIGN KEY (recorded_by_user_id) REFERENCES staff_user (id),
  CONSTRAINT chk_order_payment_method CHECK (payment_method IN ('cash', 'card', 'bank_transfer', 'other'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- KITCHEN BATCHES (unified dine-in / takeaway / delivery)
-- =============================================================================

CREATE TABLE kitchen_batch (
  id                       CHAR(36)    NOT NULL,
  restaurant_id            CHAR(36)    NOT NULL,
  session_id               CHAR(36)    NULL,
  order_id                 CHAR(36)    NULL,
  batch_number             INT         NOT NULL,
  confirmed_at             DATETIME(3) NOT NULL,
  confirmed_by_actor_type  VARCHAR(32) NOT NULL,
  confirmed_by_actor_id    CHAR(36)    NULL,
  completed_at             DATETIME(3) NULL,
  created_at               DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_batch_session_number (session_id, batch_number),
  UNIQUE KEY uq_batch_order_number (order_id, batch_number),
  KEY idx_batch_kitchen_queue (restaurant_id, confirmed_at),
  CONSTRAINT fk_batch_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_batch_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id),
  CONSTRAINT fk_batch_order
    FOREIGN KEY (order_id) REFERENCES roms_order (id),
  CONSTRAINT chk_batch_parent_xor CHECK (
    (session_id IS NOT NULL AND order_id IS NULL) OR
    (session_id IS NULL AND order_id IS NOT NULL)
  ),
  CONSTRAINT chk_batch_number CHECK (batch_number > 0),
  CONSTRAINT chk_batch_actor CHECK (confirmed_by_actor_type IN ('user', 'customer_session', 'system'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE batch_item (
  id                      CHAR(36)     NOT NULL,
  batch_id                CHAR(36)     NOT NULL,
  restaurant_id           CHAR(36)     NOT NULL,
  menu_item_id            CHAR(36)     NOT NULL,
  menu_item_name_snapshot VARCHAR(200) NOT NULL,
  unit_price_minor        BIGINT       NOT NULL,
  currency_code           CHAR(3)      NOT NULL,
  quantity                SMALLINT     NOT NULL,
  line_total_minor        BIGINT       NOT NULL,
  kitchen_notes_rendered  TEXT         NOT NULL,
  status                  VARCHAR(32)  NOT NULL DEFAULT 'preparing',
  status_updated_at       DATETIME(3)  NOT NULL,
  created_at              DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_batch_item_batch (batch_id),
  KEY idx_batch_item_restaurant_status (restaurant_id, status),
  CONSTRAINT fk_batch_item_batch
    FOREIGN KEY (batch_id) REFERENCES kitchen_batch (id),
  CONSTRAINT fk_batch_item_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT fk_batch_item_menu
    FOREIGN KEY (menu_item_id) REFERENCES menu_item (id),
  CONSTRAINT chk_batch_item_qty CHECK (quantity > 0),
  CONSTRAINT chk_batch_item_status CHECK (status IN ('preparing', 'completed', 'served'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE batch_item_customization (
  id                     CHAR(36)       NOT NULL,
  batch_item_id          CHAR(36)       NOT NULL,
  group_key              VARCHAR(64)    NOT NULL,
  group_name_snapshot    VARCHAR(100)   NOT NULL,
  option_key             VARCHAR(64)    NULL,
  option_name_snapshot   VARCHAR(100)   NULL,
  value_json             JSON           NOT NULL,
  price_delta_minor      BIGINT         NOT NULL DEFAULT 0,
  currency_code          CHAR(3)        NOT NULL,
  kitchen_label_rendered VARCHAR(200)   NOT NULL,
  created_at             DATETIME(3)    NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_batch_custom_item (batch_item_id),
  CONSTRAINT fk_batch_custom_item
    FOREIGN KEY (batch_item_id) REFERENCES batch_item (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE batch_item_status_history (
  id                 CHAR(36)    NOT NULL,
  batch_item_id      CHAR(36)    NOT NULL,
  from_status        VARCHAR(32) NULL,
  to_status          VARCHAR(32) NOT NULL,
  changed_by_user_id CHAR(36)    NULL,
  occurred_at        DATETIME(3) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_batch_status_hist (batch_item_id, occurred_at),
  CONSTRAINT fk_batch_status_item
    FOREIGN KEY (batch_item_id) REFERENCES batch_item (id),
  CONSTRAINT fk_batch_status_user
    FOREIGN KEY (changed_by_user_id) REFERENCES staff_user (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- PAYMENT (dine-in)
-- =============================================================================

CREATE TABLE session_payment (
  id                      CHAR(36)     NOT NULL,
  session_id              CHAR(36)     NOT NULL,
  payment_method          VARCHAR(32)  NOT NULL,
  close_type              VARCHAR(32)  NOT NULL DEFAULT 'payment',
  force_close_reason      VARCHAR(32)  NULL,
  force_close_note        VARCHAR(500) NULL,
  subtotal_minor          BIGINT       NOT NULL,
  tax_amount_minor        BIGINT       NOT NULL DEFAULT 0,
  service_charge_minor    BIGINT       NOT NULL DEFAULT 0,
  total_amount_minor      BIGINT       NOT NULL,
  currency_code           CHAR(3)      NOT NULL,
  closed_by_user_id       CHAR(36)     NOT NULL,
  paid_at                 DATETIME(3)  NOT NULL,
  created_at              DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_session_payment (session_id),
  CONSTRAINT fk_session_payment_session
    FOREIGN KEY (session_id) REFERENCES dine_in_session (id),
  CONSTRAINT fk_session_payment_user
    FOREIGN KEY (closed_by_user_id) REFERENCES staff_user (id),
  CONSTRAINT chk_session_payment_method CHECK (payment_method IN ('cash', 'card', 'bank_transfer', 'other')),
  CONSTRAINT chk_session_close_type CHECK (close_type IN ('payment', 'force_closed')),
  -- Flutter ForceCloseReason (@JsonValue): customer_left | dispute | system_error | other
  CONSTRAINT chk_force_close_reason CHECK (
    force_close_reason IS NULL OR force_close_reason IN (
      'customer_left', 'dispute', 'system_error', 'other'
    )
  ),
  -- Reason required when force-closing; must be null on normal payment close
  CONSTRAINT chk_force_close_reason_required CHECK (
    (close_type = 'force_closed' AND force_close_reason IS NOT NULL) OR
    (close_type = 'payment' AND force_close_reason IS NULL)
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE session_bill_line (
  id                  CHAR(36)     NOT NULL,
  session_payment_id  CHAR(36)     NOT NULL,
  batch_item_id       CHAR(36)     NOT NULL,
  description         VARCHAR(300) NOT NULL,
  quantity            SMALLINT     NOT NULL,
  unit_price_minor    BIGINT       NOT NULL,
  line_total_minor    BIGINT       NOT NULL,
  currency_code       CHAR(3)      NOT NULL,
  created_at          DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_bill_line_payment (session_payment_id),
  CONSTRAINT fk_bill_line_payment
    FOREIGN KEY (session_payment_id) REFERENCES session_payment (id),
  CONSTRAINT fk_bill_line_batch_item
    FOREIGN KEY (batch_item_id) REFERENCES batch_item (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- AUDIT / IDEMPOTENCY / OUTBOX
-- =============================================================================

CREATE TABLE audit_log (
  id              CHAR(36)     NOT NULL,
  restaurant_id   CHAR(36)     NOT NULL,
  actor_type      VARCHAR(32)  NOT NULL,
  actor_id        CHAR(36)     NULL,
  entity_type     VARCHAR(64)  NOT NULL,
  entity_id       CHAR(36)     NOT NULL,
  action          VARCHAR(32)  NOT NULL,
  before_json     JSON         NULL,
  after_json      JSON         NULL,
  metadata_json   JSON         NOT NULL,
  occurred_at     DATETIME(3)  NOT NULL,
  PRIMARY KEY (id),
  KEY idx_audit_entity (restaurant_id, entity_type, entity_id),
  KEY idx_audit_time (restaurant_id, occurred_at),
  CONSTRAINT fk_audit_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id),
  CONSTRAINT chk_audit_actor CHECK (actor_type IN ('user', 'customer_session', 'system')),
  CONSTRAINT chk_audit_action CHECK (action IN (
    'create', 'update', 'delete', 'status_change', 'close', 'claim', 'reassign', 'force_close'
  ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE idempotency_record (
  id               CHAR(36)     NOT NULL,
  restaurant_id    CHAR(36)     NOT NULL,
  idempotency_key  VARCHAR(128) NOT NULL,
  mutation_type    VARCHAR(64)  NOT NULL,
  response_json    JSON         NOT NULL,
  created_at       DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  expires_at       DATETIME(3)  NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_idempotency (restaurant_id, idempotency_key),
  KEY idx_idempotency_expires (expires_at),
  CONSTRAINT fk_idempotency_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE domain_outbox (
  id              CHAR(36)     NOT NULL,
  restaurant_id   CHAR(36)     NOT NULL,
  event_type      VARCHAR(64)  NOT NULL,
  aggregate_type  VARCHAR(64)  NOT NULL,
  aggregate_id    CHAR(36)     NOT NULL,
  payload_json    JSON         NOT NULL,
  created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  published_at    DATETIME(3)  NULL,
  PRIMARY KEY (id),
  KEY idx_outbox_unpublished (published_at, created_at),
  KEY idx_outbox_restaurant (restaurant_id),
  CONSTRAINT fk_outbox_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurant (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =============================================================================
-- KITCHEN READ MODEL (never joins payment)
-- =============================================================================

CREATE OR REPLACE VIEW v_kitchen_batch_queue AS
SELECT
  b.id                AS batch_id,
  b.restaurant_id,
  b.session_id,
  b.order_id,
  b.batch_number,
  b.confirmed_at,
  b.completed_at,
  s.display_number    AS session_display_number,
  t.label             AS table_label,
  o.order_number,
  o.order_type
FROM kitchen_batch b
LEFT JOIN dine_in_session s ON s.id = b.session_id
LEFT JOIN restaurant_table t ON t.id = s.table_id
LEFT JOIN roms_order o ON o.id = b.order_id;

-- =============================================================================
-- SEED DATA (demo parity with Flutter SessionEngineConstants)
-- Password hashes below are PLACEHOLDERS — replace with argon2id/bcrypt at deploy.
-- Demo plaintext (Flutter mock): admin123, manager123, cashier123, kitchen123, shipper123
-- =============================================================================

START TRANSACTION;

INSERT INTO restaurant (id, name, slug, timezone, is_active) VALUES
  ('demo-restaurant', 'Demo Restaurant', 'demo-restaurant', 'Asia/Ho_Chi_Minh', 1);

INSERT INTO restaurant_settings (
  id, restaurant_id, default_currency, tax_rate_bps, service_charge_bps,
  session_token_ttl_minutes, allow_qr_on_reserved_table, payment_soft_lock_enabled
) VALUES (
  'demo-settings', 'demo-restaurant', 'USD', 0, 0, 480, 0, 1
);

INSERT INTO role (id, role_key, name) VALUES
  ('role-admin', 'admin', 'Admin'),
  ('role-manager', 'manager', 'Manager'),
  ('role-cashier', 'cashier', 'Cashier'),
  ('role-kitchen', 'kitchen', 'Kitchen'),
  ('role-shipper', 'shipper', 'Shipper');

-- password_hash placeholder: REPLACE BEFORE PRODUCTION
INSERT INTO staff_user (id, restaurant_id, email, display_name, password_hash, is_active) VALUES
  ('user-admin', 'demo-restaurant', 'admin@demo.local', 'Demo Admin', '$REPLACE_WITH_ARGON2_admin123', 1),
  ('user-manager', 'demo-restaurant', 'manager@demo.local', 'Demo Manager', '$REPLACE_WITH_ARGON2_manager123', 1),
  ('user-cashier', 'demo-restaurant', 'cashier@demo.local', 'Demo Cashier', '$REPLACE_WITH_ARGON2_cashier123', 1),
  ('user-kitchen', 'demo-restaurant', 'kitchen@demo.local', 'Demo Kitchen', '$REPLACE_WITH_ARGON2_kitchen123', 1),
  ('user-shipper', 'demo-restaurant', 'shipper@demo.local', 'Demo Shipper', '$REPLACE_WITH_ARGON2_shipper123', 1);

INSERT INTO user_role (id, user_id, role_id) VALUES
  ('ur-admin', 'user-admin', 'role-admin'),
  ('ur-manager', 'user-manager', 'role-manager'),
  ('ur-cashier', 'user-cashier', 'role-cashier'),
  ('ur-kitchen', 'user-kitchen', 'role-kitchen'),
  ('ur-shipper', 'user-shipper', 'role-shipper');

INSERT INTO restaurant_table (id, restaurant_id, label, capacity, status, sort_order, is_active) VALUES
  ('table-1', 'demo-restaurant', 'Table 1', 4, 'available', 1, 1),
  ('table-2', 'demo-restaurant', 'Table 2', 4, 'available', 2, 1),
  ('table-3', 'demo-restaurant', 'Table 3', 4, 'available', 3, 1),
  ('table-4', 'demo-restaurant', 'Table 4', 2, 'available', 4, 1),
  ('table-5', 'demo-restaurant', 'Table 5', 2, 'available', 5, 1),
  ('table-6', 'demo-restaurant', 'Table 6', 6, 'available', 6, 1),
  ('table-7', 'demo-restaurant', 'Table 7', 4, 'available', 7, 1),
  ('table-8', 'demo-restaurant', 'Table 8', 4, 'available', 8, 1),
  ('table-9', 'demo-restaurant', 'Table 9', 8, 'available', 9, 1),
  ('table-10', 'demo-restaurant', 'Table 10', 4, 'available', 10, 1);

-- token_hash = SHA2 of opaque join tokens (examples; regenerate in production)
INSERT INTO table_qr_token (id, restaurant_id, table_id, token_hash, is_active) VALUES
  ('qr-1', 'demo-restaurant', 'table-1', SHA2('join_demo_table_1_token_00000001', 256), 1),
  ('qr-2', 'demo-restaurant', 'table-2', SHA2('join_demo_table_2_token_00000002', 256), 1),
  ('qr-3', 'demo-restaurant', 'table-3', SHA2('join_demo_table_3_token_00000003', 256), 1),
  ('qr-4', 'demo-restaurant', 'table-4', SHA2('join_demo_table_4_token_00000004', 256), 1),
  ('qr-5', 'demo-restaurant', 'table-5', SHA2('join_demo_table_5_token_00000005', 256), 1),
  ('qr-6', 'demo-restaurant', 'table-6', SHA2('join_demo_table_6_token_00000006', 256), 1),
  ('qr-7', 'demo-restaurant', 'table-7', SHA2('join_demo_table_7_token_00000007', 256), 1),
  ('qr-8', 'demo-restaurant', 'table-8', SHA2('join_demo_table_8_token_00000008', 256), 1),
  ('qr-9', 'demo-restaurant', 'table-9', SHA2('join_demo_table_9_token_00000009', 256), 1),
  ('qr-10', 'demo-restaurant', 'table-10', SHA2('join_demo_table_10_token_00000010', 256), 1);

INSERT INTO menu_category (id, restaurant_id, name, sort_order, is_active) VALUES
  ('cat-mains', 'demo-restaurant', 'Mains', 1, 1),
  ('cat-drinks', 'demo-restaurant', 'Drinks', 2, 1);

INSERT INTO menu_item (
  id, restaurant_id, category_id, name, description,
  base_price_minor, currency_code, availability, sort_order, is_active
) VALUES
  ('item-pho', 'demo-restaurant', 'cat-mains', 'Pho Bo', 'Beef noodle soup',
   1200, 'USD', 'available', 1, 1),
  ('item-com', 'demo-restaurant', 'cat-mains', 'Com Tam', 'Broken rice plate',
   1000, 'USD', 'available', 2, 1),
  ('item-tra', 'demo-restaurant', 'cat-drinks', 'Iced Tea', 'Fresh iced tea',
   300, 'USD', 'available', 1, 1);

INSERT INTO customization_group (
  id, menu_item_id, group_key, name, selection_type,
  is_required, min_selections, max_selections, sort_order, is_active
) VALUES
  ('grp-pho-rice', 'item-pho', 'rice_amount', 'Rice / Noodles', 'single_select', 1, 1, 1, 1, 1),
  ('grp-pho-soup', 'item-pho', 'soup', 'Soup', 'boolean', 0, 0, 1, 2, 1);

INSERT INTO customization_option (
  id, group_id, option_key, name, kitchen_label,
  price_delta_minor, currency_code, is_default, sort_order, is_active
) VALUES
  ('opt-rice-normal', 'grp-pho-rice', 'normal', 'Normal', 'Normal noodles', 0, 'USD', 1, 1, 1),
  ('opt-rice-more', 'grp-pho-rice', 'more', 'More', '+ More noodles', 100, 'USD', 0, 2, 1),
  ('opt-soup-yes', 'grp-pho-soup', 'yes', 'With soup', '+ Soup', 0, 'USD', 1, 1, 1),
  ('opt-soup-no', 'grp-pho-soup', 'no', 'No soup', '+ No Soup', 0, 'USD', 0, 2, 1);

COMMIT;

-- =============================================================================
-- END OF SCRIPT
-- =============================================================================
