// src/db/migrate.js — Creates ALL pg-managed tables
// Run: npm run db:migrate

const { query } = require('../config/db');

async function migrate() {
  console.log('\n🚀  WildX — Running full database migration...\n');

  // ── USERS (general — email/password auth) ────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS users (
      id                SERIAL        PRIMARY KEY,
      name              VARCHAR(100)  NOT NULL,
      email             VARCHAR(150)  UNIQUE NOT NULL,
      password          VARCHAR(255)  NOT NULL,
      profile_image_url TEXT,
      location          VARCHAR(150),
      bio               TEXT,
      member_since      DATE          NOT NULL DEFAULT CURRENT_DATE,
      sightings_count   INT           NOT NULL DEFAULT 0 CHECK (sightings_count >= 0),
      parks_visited     INT           NOT NULL DEFAULT 0 CHECK (parks_visited >= 0),
      photos_count      INT           NOT NULL DEFAULT 0 CHECK (photos_count >= 0),
      xp                INT           NOT NULL DEFAULT 0 CHECK (xp >= 0),
      current_level     VARCHAR(20)   NOT NULL DEFAULT 'explorer'
                          CHECK (current_level IN ('explorer', 'ranger', 'guardian')),
      created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: users');

  // ── FIREBASE USERS (Firebase auth) ───────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS firebase_users (
      id            SERIAL        PRIMARY KEY,
      firebase_uid  VARCHAR(128)  UNIQUE NOT NULL,
      email         VARCHAR(150),
      phone_number  VARCHAR(30),
      display_name  VARCHAR(150),
      photo_url     TEXT,
      auth_provider VARCHAR(30)   NOT NULL DEFAULT 'email',
      is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
      created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      last_login_at TIMESTAMPTZ
    );
  `);
  console.log('  ✅  Table: firebase_users');

  // ── PARKS ─────────────────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS parks (
      id           SERIAL        PRIMARY KEY,
      name         VARCHAR(150)  NOT NULL,
      location     VARCHAR(150)  NOT NULL,
      image_url    TEXT,
      description  TEXT,
      animal_count INTEGER       DEFAULT 0,
      is_featured  BOOLEAN       DEFAULT FALSE,
      created_at   TIMESTAMP     DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: parks');

  // ── SIGHTINGS (simple CRUD) ───────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS sightings (
      id             SERIAL        PRIMARY KEY,
      animal_name    VARCHAR(100)  NOT NULL,
      park_name      VARCHAR(150)  NOT NULL,
      sighting_date  DATE          NOT NULL,
      image_url      TEXT,
      category       VARCHAR(80)   NOT NULL,
      notes          TEXT,
      user_id        INTEGER       REFERENCES users(id) ON DELETE SET NULL,
      park_id        INTEGER       REFERENCES parks(id) ON DELETE SET NULL,
      created_at     TIMESTAMP     DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: sightings');

  // ── WILDLIFE SIGHTINGS (advanced — with geo + status) ─────────
  await query(`
    CREATE TABLE IF NOT EXISTS wildlife_sightings (
      id             SERIAL        PRIMARY KEY,
      animal_type    VARCHAR(100)  NOT NULL,
      photo_path     TEXT,
      location_name  VARCHAR(200)  NOT NULL,
      latitude       DECIMAL(9,6)  NOT NULL,
      longitude      DECIMAL(9,6)  NOT NULL,
      notes          TEXT,
      status         VARCHAR(20)   NOT NULL DEFAULT 'submitted'
                       CHECK (status IN ('submitted', 'verified', 'rejected')),
      created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: wildlife_sightings');

  // ── ANIMALS ───────────────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS animals (
      id         SERIAL        PRIMARY KEY,
      name       VARCHAR(100)  NOT NULL,
      park_name  VARCHAR(150),
      category   VARCHAR(80),
      created_at TIMESTAMP     DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: animals');

  // ── USER BADGES (simple - home page) ─────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS user_badges (
      id          SERIAL        PRIMARY KEY,
      user_id     INTEGER       REFERENCES users(id) ON DELETE CASCADE,
      badge_name  VARCHAR(100)  NOT NULL,
      badge_icon  VARCHAR(100),
      earned_at   TIMESTAMP     DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: user_badges');

  // ── BADGES (dashboard — full) ─────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS badges (
      id          SERIAL        PRIMARY KEY,
      user_id     INT           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      title       VARCHAR(100)  NOT NULL,
      icon_asset  VARCHAR(255)  NOT NULL,
      earned      BOOLEAN       NOT NULL DEFAULT FALSE,
      earned_at   TIMESTAMPTZ,
      created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: badges');

  // ── PARK VISITS ───────────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS park_visits (
      id           SERIAL        PRIMARY KEY,
      user_id      INT           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      park_name    VARCHAR(150)  NOT NULL,
      visit_count  INT           NOT NULL DEFAULT 1 CHECK (visit_count >= 1),
      last_visited DATE,
      created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: park_visits');

  // ── SOS ALERTS ────────────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS sos_alerts (
      id          SERIAL        PRIMARY KEY,
      user_id     VARCHAR(100)  NOT NULL DEFAULT 'anonymous',
      device_id   VARCHAR(100),
      latitude    DECIMAL(9,6)  NOT NULL,
      longitude   DECIMAL(9,6)  NOT NULL,
      park_name   VARCHAR(150),
      block       VARCHAR(50),
      accuracy    DECIMAL(8,2),
      message     TEXT          NOT NULL DEFAULT 'Emergency SOS triggered',
      status      VARCHAR(20)   NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending','acknowledged','resolved','false_alarm')),
      resolved_at TIMESTAMPTZ,
      created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: sos_alerts');

  // ── EMERGENCY CONTACTS ────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS emergency_contacts (
      id         SERIAL        PRIMARY KEY,
      name       VARCHAR(150)  NOT NULL,
      number     VARCHAR(30)   NOT NULL,
      emoji      VARCHAR(10)   DEFAULT '📞',
      category   VARCHAR(50)   DEFAULT 'other',
      priority   INT           DEFAULT 0,
      is_active  BOOLEAN       NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: emergency_contacts');

  // ── USER LOCATIONS ────────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS user_locations (
      id          SERIAL        PRIMARY KEY,
      user_id     VARCHAR(100)  NOT NULL DEFAULT 'anonymous',
      device_id   VARCHAR(100),
      latitude    DECIMAL(9,6)  NOT NULL,
      longitude   DECIMAL(9,6)  NOT NULL,
      park_name   VARCHAR(150),
      block       VARCHAR(50),
      accuracy    DECIMAL(8,2),
      created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: user_locations');

  // ── SAFETY TIPS ───────────────────────────────────────────────
  await query(`
    CREATE TABLE IF NOT EXISTS safety_tips (
      id         SERIAL        PRIMARY KEY,
      tip        TEXT          NOT NULL,
      category   VARCHAR(50)   NOT NULL DEFAULT 'wildlife',
      sort_order INT           NOT NULL DEFAULT 0,
      is_active  BOOLEAN       NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: safety_tips');

  // ── INDEXES ───────────────────────────────────────────────────
  await query(`CREATE INDEX IF NOT EXISTS idx_sightings_user_id     ON sightings(user_id);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_badges_user_id        ON badges(user_id);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_park_visits_user_id   ON park_visits(user_id);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_sos_status            ON sos_alerts(status);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_users_email           ON users(email);`);
  console.log('  ✅  Indexes created');

  // ── AUTO updated_at TRIGGER ───────────────────────────────────
  await query(`
    CREATE OR REPLACE FUNCTION fn_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
    $$ LANGUAGE plpgsql;
  `);
  await query(`
    DROP TRIGGER IF EXISTS trg_users_updated_at ON users;
    CREATE TRIGGER trg_users_updated_at
      BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION fn_updated_at();
  `);
  await query(`
    DROP TRIGGER IF EXISTS trg_park_visits_updated_at ON park_visits;
    CREATE TRIGGER trg_park_visits_updated_at
      BEFORE UPDATE ON park_visits FOR EACH ROW EXECUTE FUNCTION fn_updated_at();
  `);
  console.log('  ✅  Triggers created');

  // ── NATIONAL PARKS (full — from Spring Boot feature) ─────────
  await query(`
    CREATE TABLE IF NOT EXISTS national_parks (
      id                   SERIAL        PRIMARY KEY,
      name                 VARCHAR(150)  NOT NULL UNIQUE,
      description          TEXT,
      location             VARCHAR(200),
      size_in_hectares     DECIMAL(12,2),
      opening_time         TIME,
      closing_time         TIME,
      entry_fee            DECIMAL(10,2),
      image_url            TEXT,
      contact_number       VARCHAR(30),
      email                VARCHAR(150),
      best_visiting_season VARCHAR(100),
      is_active            BOOLEAN       NOT NULL DEFAULT TRUE,
      created_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: national_parks');

  await query(`
    CREATE TABLE IF NOT EXISTS park_animal_types (
      id          SERIAL       PRIMARY KEY,
      park_id     INTEGER      NOT NULL REFERENCES national_parks(id) ON DELETE CASCADE,
      animal_type VARCHAR(100) NOT NULL
    );
  `);
  console.log('  ✅  Table: park_animal_types');

  await query(`
    CREATE TABLE IF NOT EXISTS park_rules (
      id      SERIAL       PRIMARY KEY,
      park_id INTEGER      NOT NULL REFERENCES national_parks(id) ON DELETE CASCADE,
      rule    VARCHAR(500) NOT NULL
    );
  `);
  console.log('  ✅  Table: park_rules');

  // ── ANIMAL MARKERS (from Spring Boot map-marker feature) ──────
  await query(`
    CREATE TABLE IF NOT EXISTS markers (
      id            SERIAL        PRIMARY KEY,
      park_id       INTEGER       NOT NULL REFERENCES national_parks(id) ON DELETE CASCADE,
      animal_type   VARCHAR(50)   NOT NULL
                      CHECK (animal_type IN (
                        'SRI_LANKAN_LEOPARD','ASIAN_ELEPHANT','SPOTTED_DEER',
                        'CROCODILE','WATER_BUFFALO','SLOTH_BEAR'
                      )),
      latitude      DECIMAL(9,6)  NOT NULL,
      longitude     DECIMAL(9,6)  NOT NULL,
      spotted_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      reporter_name VARCHAR(150),
      notes         VARCHAR(500),
      is_verified   BOOLEAN       NOT NULL DEFAULT FALSE,
      created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    );
  `);
  console.log('  ✅  Table: markers');

  await query(`CREATE INDEX IF NOT EXISTS idx_markers_park_id       ON markers(park_id);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_markers_animal_type   ON markers(animal_type);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_markers_is_verified   ON markers(is_verified);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_national_parks_name   ON national_parks(name);`);
  await query(`CREATE INDEX IF NOT EXISTS idx_park_animal_types_pid ON park_animal_types(park_id);`);
  console.log('  ✅  Map-marker indexes created');

  console.log('\n  🎉  Migration complete!\n');
  process.exit(0);
}

migrate().catch((err) => {
  console.error('\n  ❌  Migration failed:', err.message, '\n');
  process.exit(1);
});
