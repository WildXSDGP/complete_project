// update_animals.js — Add real images to wildlife_animals
// Run: node update_animals.js
require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

const animals = [
  {
    id: '1',
    name: 'Sri Lankan Leopard',
    scientific_name: 'Panthera pardus kotiya',
    category: 'Mammals',
    park_location: 'Yala National Park',
    status: 'Endangered',
    emoji: '🐆',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/4/45/A_Female_leopard_in_Yala_National_Park.jpg',
  },
  {
    id: '2',
    name: 'Asian Elephant',
    scientific_name: 'Elephas maximus',
    category: 'Mammals',
    park_location: 'Minneriya National Park',
    status: 'Endangered',
    emoji: '🐘',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
  },
  {
    id: '3',
    name: 'Sri Lankan Sloth Bear',
    scientific_name: 'Melursus ursinus inornatus',
    category: 'Mammals',
    park_location: 'Wilpattu National Park',
    status: 'Vulnerable',
    emoji: '🐻',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/b/ba/Sloth_bear_guwahati.jpg',
  },
  {
    id: '4',
    name: 'Peacock',
    scientific_name: 'Pavo cristatus',
    category: 'Birds',
    park_location: 'Udawalawe National Park',
    status: 'Least Concern',
    emoji: '🦚',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Peacock_Plumage.jpg',
  },
  {
    id: '5',
    name: 'Purple-faced Langur',
    scientific_name: 'Trachypithecus vetulus',
    category: 'Mammals',
    park_location: 'Sinharaja Forest',
    status: 'Endangered',
    emoji: '🐒',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/3/30/Purple_faced_langur.jpg',
  },
  {
    id: '6',
    name: 'Mugger Crocodile',
    scientific_name: 'Crocodylus palustris',
    category: 'Reptiles',
    park_location: 'Yala National Park',
    status: 'Vulnerable',
    emoji: '🐊',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/a/a5/Crocodylus_palustris.jpg',
  },
  {
    id: '7',
    name: 'Sri Lanka Junglefowl',
    scientific_name: 'Gallus lafayettii',
    category: 'Birds',
    park_location: 'Horton Plains',
    status: 'Least Concern',
    emoji: '🐓',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/f/f3/Gallus_lafayettii_-_Sri_Lanka_junglefowl.jpg',
  },
  {
    id: '8',
    name: 'Indian Cobra',
    scientific_name: 'Naja naja',
    category: 'Reptiles',
    park_location: 'Bundala National Park',
    status: 'Least Concern',
    emoji: '🐍',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/3/3b/Naja_naja_zilla.jpg',
  },
];

async function run(sql, params=[]) {
  const c = await pool.connect();
  try { return await c.query(sql, params); }
  finally { c.release(); }
}

async function update() {
  console.log('\n🦁 Updating wildlife_animals with real images...\n');

  // Add image_url column if not exists
  await run(`
    ALTER TABLE wildlife_animals
    ADD COLUMN IF NOT EXISTS image_url TEXT
  `).catch(()=>{});

  for (const a of animals) {
    await run(`
      INSERT INTO wildlife_animals
        (id, name, scientific_name, category, park_location, status, emoji, image_url)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
      ON CONFLICT (id) DO UPDATE SET
        name            = EXCLUDED.name,
        scientific_name = EXCLUDED.scientific_name,
        category        = EXCLUDED.category,
        park_location   = EXCLUDED.park_location,
        status          = EXCLUDED.status,
        emoji           = EXCLUDED.emoji,
        image_url       = EXCLUDED.image_url
    `, [a.id, a.name, a.scientific_name, a.category,
        a.park_location, a.status, a.emoji, a.image_url]);
    console.log(`  ✅  ${a.name}`);
  }

  await pool.end();
  console.log('\n🎉 Done! wildlife_animals updated with real images.\n');
}

update().catch(err => {
  console.error('❌', err.message);
  pool.end();
  process.exit(1);
});
