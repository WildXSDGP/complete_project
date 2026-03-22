// src/db/seed.js — Seeds initial data into pg tables
// Run: npm run db:seed

const { query } = require('../config/db');

async function seed() {
  console.log('\n🌱  WildX — Seeding database...\n');

  // ── Parks ─────────────────────────────────────────────────────
  await query(`
    INSERT INTO parks (name, location, image_url, description, animal_count, is_featured) VALUES
      ('Yala National Park', 'Southern Province',
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       'Sri Lanka''s most visited national park, famous for leopards and elephants.', 215, TRUE),
      ('Wilpattu National Park', 'North Western Province',
       'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
       'Largest national park in Sri Lanka, famous for leopards.', 180, FALSE),
      ('Minneriya National Park', 'North Central Province',
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       'Known for The Gathering, the world''s largest elephant congregation.', 160, FALSE),
      ('Udawalawe National Park', 'Sabaragamuwa Province',
       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       'A sanctuary for Sri Lankan elephants near a reservoir.', 140, FALSE)
    ON CONFLICT DO NOTHING;
  `);
  console.log('  ✅  Parks seeded');

  // ── Emergency Contacts ────────────────────────────────────────
  await query(`
    INSERT INTO emergency_contacts (name, number, emoji, category, priority) VALUES
      ('Sri Lanka Police Emergency', '119', '🚔', 'police', 1),
      ('Ambulance / Suwa Seriya',   '1990','🚑', 'medical', 2),
      ('Fire & Rescue',              '110', '🚒', 'fire',   3),
      ('Wildlife Department Hotline','1912','🌿', 'wildlife',4),
      ('Disaster Management',        '117', '⚠️', 'disaster',5)
    ON CONFLICT DO NOTHING;
  `);
  console.log('  ✅  Emergency contacts seeded');

  // ── Safety Tips ───────────────────────────────────────────────
  await query(`
    INSERT INTO safety_tips (tip, category, sort_order) VALUES
      ('Always stay inside the vehicle during a safari drive.', 'wildlife', 1),
      ('Do not feed wild animals — it disrupts their natural behavior.', 'wildlife', 2),
      ('Keep noise levels low to avoid disturbing wildlife.', 'wildlife', 3),
      ('Carry enough water and stay hydrated in the heat.', 'general', 4),
      ('Inform the park ranger of your route before entering.', 'general', 5),
      ('Keep a first-aid kit in your vehicle at all times.', 'medical', 6),
      ('Never approach or corner a wild animal.', 'wildlife', 7),
      ('Follow all park rules and regulations.', 'general', 8)
    ON CONFLICT DO NOTHING;
  `);
  console.log('  ✅  Safety tips seeded');

  // ── Animals (reference table) ─────────────────────────────────
  await query(`
    INSERT INTO animals (name, park_name, category) VALUES
      ('Sri Lankan Leopard',    'Yala National Park',      'Mammals'),
      ('Asian Elephant',        'Minneriya National Park', 'Mammals'),
      ('Sri Lankan Sloth Bear', 'Wilpattu National Park',  'Mammals'),
      ('Peacock',               'Udawalawe National Park', 'Birds'),
      ('Purple-faced Langur',   'Sinharaja Forest',        'Mammals'),
      ('Mugger Crocodile',      'Yala National Park',      'Reptiles'),
      ('Sri Lanka Junglefowl',  'Horton Plains',           'Birds'),
      ('Indian Cobra',          'Bundala National Park',   'Reptiles')
    ON CONFLICT DO NOTHING;
  `);
  console.log('  ✅  Animals seeded');

  // ── National Parks (full data — Spring Boot model) ───────────
  const npResult = await query(`
    INSERT INTO national_parks
      (name, description, location, size_in_hectares, opening_time, closing_time,
       entry_fee, image_url, contact_number, email, best_visiting_season, is_active)
    VALUES
      ('Yala National Park',
       'Sri Lanka''s most visited national park, renowned for having one of the highest leopard densities in the world. Home to elephants, sloth bears, crocodiles, and hundreds of bird species.',
       'Southern Province, Sri Lanka', 97880, '06:00', '18:00',
       3500, 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
       '+94 47 222 0090', 'yala@wildlife.gov.lk', 'February to July', TRUE),

      ('Wilpattu National Park',
       'The largest national park in Sri Lanka, featuring unique natural lakes called "villus". Famous for leopards and the diversity of its dry zone ecosystem.',
       'North Western Province, Sri Lanka', 131693, '06:00', '18:00',
       3500, 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
       '+94 25 227 3058', 'wilpattu@wildlife.gov.lk', 'February to October', TRUE),

      ('Minneriya National Park',
       'Famous for "The Gathering" — the world''s largest Asian elephant congregation. A must-visit during dry season when hundreds of elephants converge at the Minneriya Tank.',
       'North Central Province, Sri Lanka', 8889, '06:00', '18:00',
       3000, 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 27 222 4622', 'minneriya@wildlife.gov.lk', 'August to October', TRUE),

      ('Udawalawe National Park',
       'A sanctuary for Sri Lankan elephants near a large reservoir. Excellent for elephant sightings year-round and home to the Elephant Transit Home rehabilitation center.',
       'Sabaragamuwa Province, Sri Lanka', 30821, '06:00', '18:00',
       3000, 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
       '+94 47 223 3051', 'udawalawe@wildlife.gov.lk', 'Year round', TRUE),

      ('Bundala National Park',
       'A UNESCO Biosphere Reserve and Ramsar Wetland. The premier birdwatching destination in Sri Lanka, attracting thousands of migratory flamingos and other water birds.',
       'Southern Province, Sri Lanka', 6216, '06:00', '18:00',
       2500, NULL,
       '+94 47 220 1028', 'bundala@wildlife.gov.lk', 'November to April', TRUE),

      ('Horton Plains National Park',
       'A cloud forest plateau at 2,100m elevation. Home to the famous World''s End cliff drop and Baker''s Falls. Unique montane grassland ecosystem with sambar deer.',
       'Central Province, Sri Lanka', 3160, '06:00', '18:00',
       2000, NULL,
       '+94 52 222 8899', 'hortonplains@wildlife.gov.lk', 'January to April', TRUE)

    ON CONFLICT (name) DO NOTHING
    RETURNING id, name;
  `);
  console.log(`  ✅  National parks seeded (${npResult.rows.length} inserted)`);

  // ── Animal types per park ─────────────────────────────────────
  const parkAnimalData = {
    'Yala National Park':      ['Sri Lankan Leopard','Asian Elephant','Sloth Bear','Crocodile','Spotted Deer','Water Buffalo','Peacock'],
    'Wilpattu National Park':  ['Sri Lankan Leopard','Asian Elephant','Sloth Bear','Spotted Deer','Water Buffalo'],
    'Minneriya National Park': ['Asian Elephant','Spotted Deer','Crocodile'],
    'Udawalawe National Park': ['Asian Elephant','Spotted Deer','Water Buffalo','Crocodile','Peacock'],
    'Bundala National Park':   ['Crocodile','Water Buffalo','Spotted Deer'],
    'Horton Plains National Park': ['Spotted Deer','Sloth Bear'],
  };

  const parkRulesData = {
    'Yala National Park': [
      'Stay inside the vehicle at all times during safari drives.',
      'Do not feed or disturb the wildlife.',
      'No littering — carry all waste out of the park.',
      'Night safaris require a special permit.',
      'Maximum vehicle speed is 25 km/h inside the park.',
    ],
    'Wilpattu National Park': [
      'A licensed tracker must accompany all visitors.',
      'Stay on designated tracks only.',
      'No loud music or noise that may disturb animals.',
      'Photography for personal use only — no commercial shoots without permit.',
    ],
    'Minneriya National Park': [
      'Do not leave vehicles near elephant herds.',
      'Keep a minimum distance of 50 metres from elephants.',
      'Plastic bags are strictly prohibited inside the park.',
    ],
    'Udawalawe National Park': [
      'Do not block elephant crossing paths.',
      'Visit the Elephant Transit Home between 9am–6pm only.',
      'Swimming in the reservoir is prohibited.',
    ],
    'Bundala National Park': [
      'Binoculars recommended for birdwatching.',
      'No vehicles beyond designated bird-hide points.',
      'Silence is required near nesting areas.',
    ],
    'Horton Plains National Park': [
      'Trekking permitted only on marked trails.',
      "The World's End viewpoint may be closed in bad weather.",
      'No camping without prior written permission.',
      'Collect rubbish and do not leave any trace.',
    ],
  };

  for (const row of npResult.rows) {
    const parkName = row.name;
    const pid = row.id;

    const animalTypes = parkAnimalData[parkName] || [];
    for (const at of animalTypes) {
      await query('INSERT INTO park_animal_types (park_id, animal_type) VALUES ($1,$2) ON CONFLICT DO NOTHING', [pid, at]);
    }

    const rules = parkRulesData[parkName] || [];
    for (const rule of rules) {
      await query('INSERT INTO park_rules (park_id, rule) VALUES ($1,$2)', [pid, rule]);
    }
  }
  console.log('  ✅  Park animal types and rules seeded');

  // ── Sample Markers ────────────────────────────────────────────
  // Get Yala park id for sample markers
  const yalaRes = await query(`SELECT id FROM national_parks WHERE name = 'Yala National Park' LIMIT 1`);
  if (yalaRes.rows.length > 0) {
    const yalaId = yalaRes.rows[0].id;
    await query(`
      INSERT INTO markers (park_id, animal_type, latitude, longitude, spotted_at, reporter_name, notes, is_verified)
      VALUES
        ($1, 'SRI_LANKAN_LEOPARD', 6.3726, 81.5197, NOW() - INTERVAL '2 hours',  'Ranger Silva',  'Spotted near Block 1 water hole — female with cub', TRUE),
        ($1, 'ASIAN_ELEPHANT',     6.3801, 81.5312, NOW() - INTERVAL '30 mins',  'Tracker Perera','Herd of 12 crossing the track near Section C',      FALSE),
        ($1, 'CROCODILE',          6.3650, 81.5420, NOW() - INTERVAL '5 hours',  'Guide Fernando','Two large crocs basking on the river bank',          TRUE),
        ($1, 'SPOTTED_DEER',       6.3789, 81.5268, NOW() - INTERVAL '1 hour',   'Visitor Nimal', 'Large group — approx 30 deer near the grasslands',   FALSE),
        ($1, 'SLOTH_BEAR',         6.3710, 81.5180, NOW() - INTERVAL '3 hours',  'Ranger Silva',  'Mother and young spotted in the rocky area',         TRUE)
      ON CONFLICT DO NOTHING;
    `, [yalaId]);
    console.log('  ✅  Sample markers seeded (Yala)');
  }

  console.log('\n  🎉  Seed complete!\n');
  process.exit(0);
}

seed().catch((err) => {
  console.error('\n  ❌  Seed failed:', err.message, '\n');
  process.exit(1);
});
