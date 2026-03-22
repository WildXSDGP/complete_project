// smart_migrate.js
// දැනටමත් ඇති tables skip කරනවා — නැති ඒවා විතරක් හදනවා
require('dotenv').config();
const { query } = require('./src/config/db');

async function getExistingTables() {
  const res = await query(
    `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'`
  );
  return new Set(res.rows.map(r => r.table_name));
}

async function createIfMissing(tableName, sql, existing) {
  if (existing.has(tableName)) {
    console.log(`  ⏭️  Skip (already exists): ${tableName}`);
    return;
  }
  await query(sql);
  console.log(`  ✅  Created: ${tableName}`);
}

async function smartMigrate() {
  console.log('\n🔍  Checking existing tables in your Neon DB...\n');
  const existing = await getExistingTables();

  if (existing.size > 0) {
    console.log(`  📋  Found ${existing.size} existing table(s): ${[...existing].join(', ')}\n`);
  } else {
    console.log('  📋  No existing tables found — fresh database.\n');
  }

  console.log('🚀  Creating missing tables...\n');

  await createIfMissing('users', `
    CREATE TABLE users (
      id                SERIAL        PRIMARY KEY,
      name              VARCHAR(100)  NOT NULL,
      email             VARCHAR(150)  UNIQUE NOT NULL,
      password          VARCHAR(255)  NOT NULL,
      profile_image_url TEXT,
      location          VARCHAR(150),
      bio               TEXT,
      member_since      DATE          NOT NULL DEFAULT CURRENT_DATE,
      sightings_count   INT           NOT NULL DEFAULT 0,
      parks_visited     INT           NOT NULL DEFAULT 0,
      photos_count      INT           NOT NULL DEFAULT 0,
      xp                INT           NOT NULL DEFAULT 0,
      current_level     VARCHAR(20)   NOT NULL DEFAULT 'explorer',
      created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('firebase_users', `
    CREATE TABLE firebase_users (
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
    )`, existing);

  await createIfMissing('parks', `
    CREATE TABLE parks (
      id           SERIAL        PRIMARY KEY,
      name         VARCHAR(150)  NOT NULL,
      location     VARCHAR(150)  NOT NULL,
      image_url    TEXT,
      description  TEXT,
      animal_count INTEGER       DEFAULT 0,
      is_featured  BOOLEAN       DEFAULT FALSE,
      created_at   TIMESTAMP     DEFAULT NOW()
    )`, existing);

  await createIfMissing('sightings', `
    CREATE TABLE sightings (
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
    )`, existing);

  await createIfMissing('wildlife_sightings', `
    CREATE TABLE wildlife_sightings (
      id             SERIAL        PRIMARY KEY,
      animal_type    VARCHAR(100)  NOT NULL,
      photo_path     TEXT,
      location_name  VARCHAR(200)  NOT NULL,
      latitude       DECIMAL(9,6)  NOT NULL,
      longitude      DECIMAL(9,6)  NOT NULL,
      notes          TEXT,
      status         VARCHAR(20)   NOT NULL DEFAULT 'submitted',
      created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('animals', `
    CREATE TABLE animals (
      id         SERIAL        PRIMARY KEY,
      name       VARCHAR(100)  NOT NULL,
      park_name  VARCHAR(150),
      category   VARCHAR(80),
      created_at TIMESTAMP     DEFAULT NOW()
    )`, existing);

  await createIfMissing('user_badges', `
    CREATE TABLE user_badges (
      id          SERIAL        PRIMARY KEY,
      user_id     INTEGER       REFERENCES users(id) ON DELETE CASCADE,
      badge_name  VARCHAR(100)  NOT NULL,
      badge_icon  VARCHAR(100),
      earned_at   TIMESTAMP     DEFAULT NOW()
    )`, existing);

  await createIfMissing('badges', `
    CREATE TABLE badges (
      id          SERIAL        PRIMARY KEY,
      user_id     INT           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      title       VARCHAR(100)  NOT NULL,
      icon_asset  VARCHAR(255)  NOT NULL,
      earned      BOOLEAN       NOT NULL DEFAULT FALSE,
      earned_at   TIMESTAMPTZ,
      created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('park_visits', `
    CREATE TABLE park_visits (
      id           SERIAL        PRIMARY KEY,
      user_id      INT           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      park_name    VARCHAR(150)  NOT NULL,
      visit_count  INT           NOT NULL DEFAULT 1,
      last_visited DATE,
      created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('sos_alerts', `
    CREATE TABLE sos_alerts (
      id          SERIAL        PRIMARY KEY,
      user_id     VARCHAR(100)  NOT NULL DEFAULT 'anonymous',
      device_id   VARCHAR(100),
      latitude    DECIMAL(9,6)  NOT NULL,
      longitude   DECIMAL(9,6)  NOT NULL,
      park_name   VARCHAR(150),
      block       VARCHAR(50),
      accuracy    DECIMAL(8,2),
      message     TEXT          NOT NULL DEFAULT 'Emergency SOS triggered',
      status      VARCHAR(20)   NOT NULL DEFAULT 'pending',
      resolved_at TIMESTAMPTZ,
      created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('emergency_contacts', `
    CREATE TABLE emergency_contacts (
      id         SERIAL        PRIMARY KEY,
      name       VARCHAR(150)  NOT NULL,
      number     VARCHAR(30)   NOT NULL,
      emoji      VARCHAR(10)   DEFAULT '📞',
      category   VARCHAR(50)   DEFAULT 'other',
      priority   INT           DEFAULT 0,
      is_active  BOOLEAN       NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('user_locations', `
    CREATE TABLE user_locations (
      id          SERIAL        PRIMARY KEY,
      user_id     VARCHAR(100)  NOT NULL DEFAULT 'anonymous',
      device_id   VARCHAR(100),
      latitude    DECIMAL(9,6)  NOT NULL,
      longitude   DECIMAL(9,6)  NOT NULL,
      park_name   VARCHAR(150),
      block       VARCHAR(50),
      accuracy    DECIMAL(8,2),
      created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('safety_tips', `
    CREATE TABLE safety_tips (
      id         SERIAL        PRIMARY KEY,
      tip        TEXT          NOT NULL,
      category   VARCHAR(50)   NOT NULL DEFAULT 'wildlife',
      sort_order INT           NOT NULL DEFAULT 0,
      is_active  BOOLEAN       NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  await createIfMissing('national_parks', `
    CREATE TABLE national_parks (
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
    )`, existing);

  await createIfMissing('park_animal_types', `
    CREATE TABLE park_animal_types (
      id          SERIAL       PRIMARY KEY,
      park_id     INTEGER      NOT NULL REFERENCES national_parks(id) ON DELETE CASCADE,
      animal_type VARCHAR(100) NOT NULL
    )`, existing);

  await createIfMissing('park_rules', `
    CREATE TABLE park_rules (
      id      SERIAL       PRIMARY KEY,
      park_id INTEGER      NOT NULL REFERENCES national_parks(id) ON DELETE CASCADE,
      rule    VARCHAR(500) NOT NULL
    )`, existing);

  await createIfMissing('markers', `
    CREATE TABLE markers (
      id            SERIAL        PRIMARY KEY,
      park_id       INTEGER       NOT NULL REFERENCES national_parks(id) ON DELETE CASCADE,
      animal_type   VARCHAR(50)   NOT NULL,
      latitude      DECIMAL(9,6)  NOT NULL,
      longitude     DECIMAL(9,6)  NOT NULL,
      spotted_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
      reporter_name VARCHAR(150),
      notes         VARCHAR(500),
      is_verified   BOOLEAN       NOT NULL DEFAULT FALSE,
      created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
    )`, existing);

  // ── Indexes (IF NOT EXISTS is safe) ─────────────────────────
  console.log('\n  📇  Creating indexes (safe to re-run)...');
  const indexes = [
    `CREATE INDEX IF NOT EXISTS idx_sightings_user_id   ON sightings(user_id)`,
    `CREATE INDEX IF NOT EXISTS idx_badges_user_id      ON badges(user_id)`,
    `CREATE INDEX IF NOT EXISTS idx_park_visits_user_id ON park_visits(user_id)`,
    `CREATE INDEX IF NOT EXISTS idx_sos_status          ON sos_alerts(status)`,
    `CREATE INDEX IF NOT EXISTS idx_users_email         ON users(email)`,
    `CREATE INDEX IF NOT EXISTS idx_markers_park_id     ON markers(park_id)`,
    `CREATE INDEX IF NOT EXISTS idx_national_parks_name ON national_parks(name)`,
  ];
  for (const idx of indexes) {
    await query(idx).catch(() => {}); // silently skip if exists
  }
  console.log('  ✅  Indexes done');

  // ── Trigger (idempotent) ─────────────────────────────────────
  await query(`
    CREATE OR REPLACE FUNCTION fn_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
    $$ LANGUAGE plpgsql
  `).catch(() => {});

  // ── Final summary ────────────────────────────────────────────
  const finalTables = await getExistingTables();
  console.log(`\n✅  Done! Your DB now has ${finalTables.size} tables:`);
  console.log('   ', [...finalTables].sort().join(', '));
  console.log('');
  process.exit(0);
}

smartMigrate().catch(err => {
  console.error('\n❌  Error:', err.message);
  process.exit(1);
});
