// setup.js — WildX One-Time Database Setup
// Run: node setup.js
// Creates ALL missing tables and seeds initial data into your Neon DB.
// Safe to run multiple times — uses IF NOT EXISTS + ON CONFLICT DO NOTHING.

require('dotenv').config();
const { Pool } = require('pg');

if (!process.env.DATABASE_URL) {
  console.error('❌  DATABASE_URL not found in .env');
  process.exit(1);
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

async function run(sql, params = []) {
  const client = await pool.connect();
  try { return await client.query(sql, params); }
  finally { client.release(); }
}

async function setup() {
  console.log('\n🚀  WildX — Database Setup\n');

  // ── 1. Seed national_parks (oya DB eke already thibba) ─────────
  console.log('📍  Seeding national_parks...');
  await run(`
    INSERT INTO national_parks
      (name, description, location, size_in_hectares,
       opening_time, closing_time, entry_fee, image_url,
       contact_number, best_visiting_season, is_active)
    VALUES
      ('Yala National Park',
       'Sri Lanka''s most visited national park, famous for leopards and elephants.',
       'Southern Province', 97880,
       '06:00', '18:00', 15.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 47 222 0450', 'February to July', true),

      ('Wilpattu National Park',
       'Largest national park in Sri Lanka, famous for leopards and villus.',
       'North Western Province', 131693,
       '06:00', '18:00', 15.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
       '+94 25 222 3201', 'February to October', true),

      ('Minneriya National Park',
       'Known for The Gathering — the world''s largest elephant congregation.',
       'North Central Province', 8889,
       '06:00', '18:00', 12.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 27 222 4052', 'June to October', true),

      ('Udawalawe National Park',
       'A sanctuary for Sri Lankan elephants near the Udawalawe reservoir.',
       'Sabaragamuwa Province', 30821,
       '06:00', '18:00', 12.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 47 223 0732', 'May to September', true),

      ('Horton Plains National Park',
       'A highland plateau with World''s End cliff and stunning biodiversity.',
       'Central Province', 3160,
       '06:00', '18:00', 20.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/World%27s_End%2C_Horton_Plains.jpg/1280px-World%27s_End%2C_Horton_Plains.jpg',
       '+94 52 222 8740', 'January to April', true),

      ('Bundala National Park',
       'A wetland sanctuary and a Ramsar site, famous for flamingos and migratory birds.',
       'Southern Province', 6216,
       '06:00', '18:00', 10.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 47 223 8471', 'November to March', true),

      ('Sinharaja Forest Reserve',
       'Sri Lanka''s last viable area of primary tropical rainforest — UNESCO World Heritage Site.',
       'Sabaragamuwa Province', 8864,
       '07:00', '16:00', 8.0,
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 45 222 5859', 'August and January', true)
    ON CONFLICT (name) DO NOTHING
  `);
  console.log('  ✅  national_parks seeded');

  // ── 2. Seed park_animal_types ──────────────────────────────────
  console.log('🐾  Seeding park_animal_types...');
  const parks = await run(`SELECT id, name FROM national_parks ORDER BY id`);
  for (const park of parks.rows) {
    const animals = {
      'Yala National Park':         ['Leopard','Elephant','Crocodile','Spotted Deer','Wild Buffalo','Sloth Bear'],
      'Wilpattu National Park':     ['Leopard','Elephant','Sloth Bear','Spotted Deer','Jackal'],
      'Minneriya National Park':    ['Elephant','Spotted Deer','Painted Stork','Eagle','Crocodile'],
      'Udawalawe National Park':    ['Elephant','Water Buffalo','Crocodile','Eagle','Wild Boar'],
      'Horton Plains National Park':['Sambar Deer','Leopard','Purple-faced Langur','Bear','Birds'],
      'Bundala National Park':      ['Flamingo','Crocodile','Elephant','Pelican','Painted Stork'],
      'Sinharaja Forest Reserve':   ['Purple-faced Langur','Leopard','Birds','Reptiles','Butterflies'],
    }[park.name] || [];

    for (const animal of animals) {
      await run(
        `INSERT INTO park_animal_types (park_id, animal_type) VALUES ($1, $2)
         ON CONFLICT DO NOTHING`,
        [park.id, animal]
      ).catch(() => {});
    }
  }
  console.log('  ✅  park_animal_types seeded');

  // ── 3. Seed park_rules ─────────────────────────────────────────
  console.log('📋  Seeding park_rules...');
  const commonRules = [
    'Do not exit the vehicle inside the park',
    'Strictly no feeding of animals',
    'No littering — carry your waste out',
    'Keep noise levels low',
    'No flash photography near animals',
    'Follow the designated routes only',
  ];
  for (const park of parks.rows) {
    for (const rule of commonRules) {
      await run(
        `INSERT INTO park_rules (park_id, rule) VALUES ($1, $2)
         ON CONFLICT DO NOTHING`,
        [park.id, rule]
      ).catch(() => {});
    }
  }
  console.log('  ✅  park_rules seeded');

  // ── 4. Create sos_alerts table ─────────────────────────────────
  console.log('🆘  Creating sos_alerts table...');
  await run(`
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
    )
  `);
  console.log('  ✅  sos_alerts table ready');

  // ── 5. Create emergency_contacts table ────────────────────────
  console.log('📞  Creating emergency_contacts...');
  await run(`
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
    )
  `);
  await run(`
    INSERT INTO emergency_contacts (name, number, emoji, category, priority) VALUES
      ('Sri Lanka Police',        '119',  '🚔', 'police',   1),
      ('Ambulance / Suwa Seriya', '1990', '🚑', 'medical',  2),
      ('Fire & Rescue',           '110',  '🚒', 'fire',     3),
      ('Wildlife Department',     '1912', '🌿', 'wildlife', 4),
      ('Disaster Management',     '117',  '⚠️', 'disaster', 5)
    ON CONFLICT DO NOTHING
  `).catch(() => {});
  console.log('  ✅  emergency_contacts ready');

  // ── 6. Create safety_tips table ───────────────────────────────
  console.log('💡  Creating safety_tips...');
  await run(`
    CREATE TABLE IF NOT EXISTS safety_tips (
      id         SERIAL      PRIMARY KEY,
      tip        TEXT        NOT NULL,
      category   VARCHAR(50) NOT NULL DEFAULT 'wildlife',
      sort_order INT         NOT NULL DEFAULT 0,
      is_active  BOOLEAN     NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
  await run(`
    INSERT INTO safety_tips (tip, category, sort_order) VALUES
      ('Always stay inside the vehicle during a safari drive.', 'wildlife', 1),
      ('Never feed wild animals — it disrupts their natural behavior.', 'wildlife', 2),
      ('Keep noise levels low to avoid disturbing wildlife.', 'wildlife', 3),
      ('Carry enough water and stay hydrated in the heat.', 'general', 4),
      ('Inform the park ranger of your route before entering.', 'general', 5),
      ('Keep a first-aid kit in your vehicle at all times.', 'medical', 6),
      ('Never approach or corner a wild animal.', 'wildlife', 7),
      ('Follow all park rules and regulations strictly.', 'general', 8)
    ON CONFLICT DO NOTHING
  `).catch(() => {});
  console.log('  ✅  safety_tips ready');

  // ── 7. Create user_locations table ────────────────────────────
  await run(`
    CREATE TABLE IF NOT EXISTS user_locations (
      id         SERIAL       PRIMARY KEY,
      user_id    VARCHAR(100) NOT NULL DEFAULT 'anonymous',
      device_id  VARCHAR(100),
      latitude   DECIMAL(9,6) NOT NULL,
      longitude  DECIMAL(9,6) NOT NULL,
      park_name  VARCHAR(150),
      block      VARCHAR(50),
      accuracy   DECIMAL(8,2),
      created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
    )
  `);
  console.log('  ✅  user_locations table ready');

  // ── 8. Prisma: parks_prisma table for accommodations ──────────
  console.log('🏕️   Creating accommodation tables (Prisma)...');
  await run(`
    CREATE TABLE IF NOT EXISTS parks_prisma (
      id          TEXT PRIMARY KEY,
      name        TEXT UNIQUE NOT NULL,
      description TEXT,
      created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
  await run(`
    INSERT INTO parks_prisma (id, name, description) VALUES
      ('park_yala',      'Yala National Park',      'Famous for leopards'),
      ('park_wilpattu',  'Wilpattu National Park',  'Largest national park'),
      ('park_minneriya', 'Minneriya National Park', 'The Gathering'),
      ('park_udawalawe', 'Udawalawe National Park', 'Elephant sanctuary'),
      ('park_horton',    'Horton Plains',           'Highland plateau'),
      ('park_bundala',   'Bundala National Park',   'Bird sanctuary'),
      ('park_sinharaja', 'Sinharaja Forest Reserve','Rainforest UNESCO site')
    ON CONFLICT (name) DO NOTHING
  `);

  await run(`
    CREATE TABLE IF NOT EXISTS accommodations_prisma (
      id                  TEXT PRIMARY KEY,
      name                TEXT NOT NULL,
      park_id             TEXT NOT NULL REFERENCES parks_prisma(id),
      price_per_night     DECIMAL(10,2) NOT NULL,
      distance_from_gate  DECIMAL(5,2)  NOT NULL,
      travel_time         TEXT NOT NULL,
      fuel_stops          INT  NOT NULL DEFAULT 0,
      rating              DECIMAL(2,1) NOT NULL DEFAULT 0.0,
      is_eco_friendly     BOOLEAN NOT NULL DEFAULT false,
      is_family_friendly  BOOLEAN NOT NULL DEFAULT false,
      has_jeep_hire       BOOLEAN NOT NULL DEFAULT false,
      description         TEXT,
      created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
  await run(`
    INSERT INTO accommodations_prisma (id, name, park_id, price_per_night, distance_from_gate, travel_time, fuel_stops, rating, is_eco_friendly, is_family_friendly, has_jeep_hire, description) VALUES
      ('acc_001', 'Green Valley Eco-Lodge',   'park_yala',      9500,  4.0, '20 mins', 1, 4.9, true,  true,  true,  'Serene eco-lodge with panoramic wilderness views'),
      ('acc_002', 'Yala Safari Lodge',        'park_yala',      8500,  2.5, '12 mins', 1, 4.7, true,  false, false, 'Intimate safari camp near the main gate'),
      ('acc_003', 'Wilpattu Forest Camp',     'park_wilpattu',  6200,  1.2, '10 mins', 0, 4.5, false, false, false, 'Rustic camp deep inside Wilpattu'),
      ('acc_004', 'Minneriya Elephant Lodge', 'park_minneriya', 7800,  3.5, '15 mins', 1, 4.6, true,  true,  true,  'Experience The Gathering up close'),
      ('acc_005', 'Udawalawe River Camp',     'park_udawalawe', 5900,  2.0, '10 mins', 0, 4.4, true,  true,  false, 'Riverside camp with elephant herds'),
      ('acc_006', 'Horton Mist Retreat',      'park_horton',    12000, 5.0, '25 mins', 2, 4.8, true,  false, false, 'Cozy highland retreat with misty mornings')
    ON CONFLICT (id) DO NOTHING
  `);

  await run(`
    CREATE TABLE IF NOT EXISTS accommodation_images (
      id               SERIAL PRIMARY KEY,
      accommodation_id TEXT   NOT NULL REFERENCES accommodations_prisma(id) ON DELETE CASCADE,
      image_url        TEXT   NOT NULL,
      sort_order       INT    NOT NULL DEFAULT 0
    )
  `);
  await run(`
    INSERT INTO accommodation_images (accommodation_id, image_url, sort_order) VALUES
      ('acc_001','https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/800px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',0),
      ('acc_001','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',1),
      ('acc_002','https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/800px-Leopard_sitting_2.jpg',0),
      ('acc_003','https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/800px-Sloth_bear_guwahati.jpg',0),
      ('acc_004','https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/800px-Peacock_Plumage.jpg',0),
      ('acc_005','https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/800px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',0),
      ('acc_006','https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/800px-Leopard_sitting_2.jpg',0)
    ON CONFLICT DO NOTHING
  `).catch(() => {});
  console.log('  ✅  Accommodation tables ready');

  // ── 9. Sequelize: wildlife_animals & wildlife_photos ──────────
  console.log('🦁  Creating gallery tables (Sequelize)...');
  await run(`
    CREATE TABLE IF NOT EXISTS wildlife_animals (
      id              TEXT PRIMARY KEY,
      name            TEXT NOT NULL,
      scientific_name TEXT NOT NULL,
      category        TEXT NOT NULL,
      park_location   TEXT NOT NULL,
      status          TEXT NOT NULL DEFAULT 'Least Concern',
      emoji           TEXT DEFAULT '🐾',
      is_favorite     BOOLEAN NOT NULL DEFAULT false,
      created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
  await run(`
    INSERT INTO wildlife_animals (id, name, scientific_name, category, park_location, status, emoji) VALUES
      ('1','Sri Lankan Leopard',    'Panthera pardus kotiya',    'Mammals',  'Yala National Park',      'Endangered',    '🐆'),
      ('2','Asian Elephant',        'Elephas maximus',            'Mammals',  'Minneriya National Park', 'Endangered',    '🐘'),
      ('3','Sri Lankan Sloth Bear', 'Melursus ursinus inornatus', 'Mammals',  'Wilpattu National Park',  'Vulnerable',    '🐻'),
      ('4','Peacock',               'Pavo cristatus',             'Birds',    'Udawalawe National Park', 'Least Concern', '🦚'),
      ('5','Purple-faced Langur',   'Trachypithecus vetulus',     'Mammals',  'Sinharaja Forest',        'Endangered',    '🐒'),
      ('6','Mugger Crocodile',      'Crocodylus palustris',       'Reptiles', 'Yala National Park',      'Vulnerable',    '🐊'),
      ('7','Sri Lanka Junglefowl',  'Gallus lafayettii',          'Birds',    'Horton Plains',           'Least Concern', '🐓'),
      ('8','Indian Cobra',          'Naja naja',                  'Reptiles', 'Bundala National Park',   'Least Concern', '🐍')
    ON CONFLICT (id) DO NOTHING
  `);
  await run(`
    CREATE TABLE IF NOT EXISTS wildlife_photos (
      id           SERIAL PRIMARY KEY,
      image_url    TEXT NOT NULL,
      animal_type  TEXT NOT NULL,
      park_name    TEXT NOT NULL,
      uploaded_by  TEXT NOT NULL DEFAULT 'WildX',
      uploaded_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
  await run(`
    INSERT INTO wildlife_photos (image_url, animal_type, park_name, uploaded_by) VALUES
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/400px-Leopard_sitting_2.jpg', 'Leopard', 'Yala National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/400px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg', 'Elephant', 'Yala National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/400px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg', 'Elephant', 'Udawalawe National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/400px-Peacock_Plumage.jpg', 'Bird', 'Bundala National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/400px-Sloth_bear_guwahati.jpg', 'Sloth Bear', 'Wilpattu National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/400px-Leopard_sitting_2.jpg', 'Leopard', 'Wilpattu National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/400px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg', 'Elephant', 'Minneriya National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/400px-Peacock_Plumage.jpg', 'Peacock', 'Udawalawe National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/400px-Sloth_bear_guwahati.jpg', 'Sloth Bear', 'Yala National Park', 'WildX'),
      ('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/400px-Leopard_sitting_2.jpg', 'Leopard', 'Yala National Park', 'WildX')
    ON CONFLICT DO NOTHING
  `).catch(() => {});
  console.log('  ✅  Gallery tables ready');

  // ── 10. Notifications table ────────────────────────────────────
  console.log('🔔  Creating notifications table...');
  await run(`
    CREATE TABLE IF NOT EXISTS notifications (
      id         SERIAL PRIMARY KEY,
      title      TEXT NOT NULL,
      body       TEXT NOT NULL,
      type       TEXT NOT NULL DEFAULT 'general',
      is_read    BOOLEAN NOT NULL DEFAULT false,
      user_id    TEXT,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
  await run(`
    INSERT INTO notifications (title, body, type) VALUES
      ('Welcome to WildX! 🦁', 'Start exploring Sri Lanka''s amazing wildlife.', 'welcome'),
      ('New Sighting Nearby 🐘', 'An elephant herd was spotted at Minneriya today.', 'sighting'),
      ('Park Alert 🚨', 'Yala Block 1 is open for visitors this week.', 'alert')
    ON CONFLICT DO NOTHING
  `).catch(() => {});
  console.log('  ✅  Notifications table ready');

  // ── Ensure users.firebase_uid has UNIQUE constraint ────────
  console.log('👤  Checking users table constraints...');
  await run(`
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'users_firebase_uid_key'
        AND conrelid = 'users'::regclass
      ) THEN
        ALTER TABLE users ADD CONSTRAINT users_firebase_uid_key UNIQUE (firebase_uid);
      END IF;
    END $$;
  `).catch(() => {});
  console.log('  ✅  users.firebase_uid unique constraint ready');

  await pool.end();
  console.log('\n🎉  Setup complete! All tables created and seeded.\n');
  console.log('Now run: npm run dev\n');
}

setup().catch(err => {
  console.error('\n❌  Setup failed:', err.message);
  pool.end();
  process.exit(1);
});
