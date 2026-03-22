// update_parks.js — Update national_parks with real images + data
// Run: node update_parks.js
require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

const parks = [
  {
    name: 'Yala National Park',
    description: 'Sri Lanka\'s most popular national park, famous for the highest density of leopards in the world. Also home to elephants, crocodiles, and hundreds of bird species.',
    location: 'Hambantota District, Southern Province',
    size_in_hectares: 97880,
    opening_time: '06:00:00',
    closing_time: '18:00:00',
    entry_fee: 3500,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_Female_leopard_in_Yala_National_Park.jpg/1280px-A_Female_leopard_in_Yala_National_Park.jpg',
    contact_number: '+94 47 222 0450',
    best_visiting_season: 'February to July',
    animals: ['Asian Elephant','Sri Lankan Leopard','Spotted Deer','Crocodile','Water Buffalo','Sloth Bear','Peacock'],
    rules: [
      'Do not exit the vehicle inside the park',
      'Strictly no feeding of animals',
      'No littering — carry waste out',
      'Keep noise levels low',
      'No flash photography near animals',
    ],
  },
  {
    name: 'Wilpattu National Park',
    description: 'The largest national park in Sri Lanka, known for its natural lakes (villus) and rich leopard population. A true wilderness experience.',
    location: 'North Western Province',
    size_in_hectares: 131693,
    opening_time: '06:00:00',
    closing_time: '18:00:00',
    entry_fee: 3500,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
    contact_number: '+94 25 222 3201',
    best_visiting_season: 'February to October',
    animals: ['Sri Lankan Leopard','Asian Elephant','Sloth Bear','Spotted Deer','Jackal'],
    rules: [
      'Stay in the vehicle at all times',
      'No noise or loud music',
      'Follow designated routes only',
      'No plastic bags inside the park',
    ],
  },
  {
    name: 'Minneriya National Park',
    description: 'Home to The Gathering — the world\'s largest congregation of Asian elephants. The Minneriya tank attracts hundreds of elephants during dry season.',
    location: 'North Central Province',
    size_in_hectares: 8889,
    opening_time: '06:00:00',
    closing_time: '18:00:00',
    entry_fee: 3000,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
    contact_number: '+94 27 222 4052',
    best_visiting_season: 'June to October',
    animals: ['Asian Elephant','Spotted Deer','Eagle','Crocodile','Painted Stork'],
    rules: [
      'Do not block elephant paths',
      'Photography allowed, no flash at night',
      'Stay in vehicle during The Gathering',
    ],
  },
  {
    name: 'Udawalawe National Park',
    description: 'A sanctuary for Sri Lankan elephants near the Udawalawe reservoir. One of the best places in Asia to see wild elephants.',
    location: 'Sabaragamuwa and Uva Provinces',
    size_in_hectares: 30821,
    opening_time: '06:00:00',
    closing_time: '18:00:00',
    entry_fee: 3000,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Udawalawa_Elephant.jpg/1280px-Udawalawa_Elephant.jpg',
    contact_number: '+94 47 223 0732',
    best_visiting_season: 'May to September',
    animals: ['Asian Elephant','Water Buffalo','Crocodile','Eagle','Wild Boar','Spotted Deer'],
    rules: [
      'Keep vehicle engines off near animals',
      'No plastic bags inside the park',
      'Do not disturb nesting birds',
    ],
  },
  {
    name: 'Horton Plains National Park',
    description: 'A highland plateau at 2,100m altitude featuring World\'s End cliff, Baker\'s Falls, and unique cloud forest ecosystems.',
    location: 'Central Province',
    size_in_hectares: 3160,
    opening_time: '06:00:00',
    closing_time: '18:00:00',
    entry_fee: 3500,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Horton_Plains_National_Park_World%27s_End.jpg/1280px-Horton_Plains_National_Park_World%27s_End.jpg',
    contact_number: '+94 52 222 8740',
    best_visiting_season: 'January to April',
    animals: ['Sambar Deer','Purple-faced Langur','Sloth Bear','Birds'],
    rules: [
      'Stay on designated trails',
      'No vehicles beyond parking area',
      'Visit World\'s End before 9am for clear views',
    ],
  },
  {
    name: 'Bundala National Park',
    description: 'A Ramsar wetland site and bird sanctuary famous for flamingos and migratory birds from Siberia and India.',
    location: 'Southern Province',
    size_in_hectares: 6216,
    opening_time: '06:00:00',
    closing_time: '18:00:00',
    entry_fee: 2500,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
    contact_number: '+94 47 223 8471',
    best_visiting_season: 'November to March',
    animals: ['Asian Elephant','Crocodile','Painted Stork','Flamingo','Pelican'],
    rules: [
      'No disturbance to nesting birds',
      'Binoculars recommended',
    ],
  },
  {
    name: 'Sinharaja Forest Reserve',
    description: 'Sri Lanka\'s last viable primary tropical rainforest and UNESCO World Heritage Site. Home to endemic species found nowhere else on Earth.',
    location: 'Sabaragamuwa Province',
    size_in_hectares: 8864,
    opening_time: '07:00:00',
    closing_time: '16:00:00',
    entry_fee: 2500,
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/800px-Peacock_Plumage.jpg',
    contact_number: '+94 45 222 5859',
    best_visiting_season: 'August and January',
    animals: ['Purple-faced Langur','Sri Lankan Leopard','Birds','Reptiles'],
    rules: [
      'Guides are mandatory',
      'No collection of plants or animals',
      'Stay on marked trails only',
    ],
  },
];

async function run(sql, params = []) {
  const client = await pool.connect();
  try { return await client.query(sql, params); }
  finally { client.release(); }
}

async function update() {
  console.log('\n🌿 Updating national_parks with real data...\n');

  for (const park of parks) {
    // Upsert park
    const r = await run(
      `INSERT INTO national_parks
         (name, description, location, size_in_hectares, opening_time,
          closing_time, entry_fee, image_url, contact_number,
          best_visiting_season, is_active)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,true)
       ON CONFLICT (name) DO UPDATE SET
         description         = EXCLUDED.description,
         location            = EXCLUDED.location,
         size_in_hectares    = EXCLUDED.size_in_hectares,
         opening_time        = EXCLUDED.opening_time,
         closing_time        = EXCLUDED.closing_time,
         entry_fee           = EXCLUDED.entry_fee,
         image_url           = EXCLUDED.image_url,
         contact_number      = EXCLUDED.contact_number,
         best_visiting_season= EXCLUDED.best_visiting_season,
         is_active           = true
       RETURNING id, name`,
      [park.name, park.description, park.location, park.size_in_hectares,
       park.opening_time, park.closing_time, park.entry_fee, park.image_url,
       park.contact_number, park.best_visiting_season]
    );
    const parkId = r.rows[0].id;
    console.log(`  ✅ ${park.name} (id: ${parkId})`);

    // Clear and re-insert animal types
    await run('DELETE FROM park_animal_types WHERE park_id=$1', [parkId]);
    for (const animal of park.animals) {
      await run(
        'INSERT INTO park_animal_types (park_id, animal_type) VALUES ($1,$2)',
        [parkId, animal]
      );
    }

    // Clear and re-insert rules
    await run('DELETE FROM park_rules WHERE park_id=$1', [parkId]);
    for (const rule of park.rules) {
      await run(
        'INSERT INTO park_rules (park_id, rule) VALUES ($1,$2)',
        [parkId, rule]
      );
    }
  }

  await pool.end();
  console.log('\n🎉 Done! national_parks updated with real images + data.\n');
  console.log('Now run: npm run dev\n');
}

update().catch(err => {
  console.error('\n❌ Failed:', err.message);
  pool.end();
  process.exit(1);
});
