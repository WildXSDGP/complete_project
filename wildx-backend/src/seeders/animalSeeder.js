// src/seeders/animalSeeder.js
const WildlifeAnimal = require('../models/WildlifeAnimal');

const seedAnimals = [
  { id:'1', name:'Sri Lankan Leopard',    scientificName:'Panthera pardus kotiya',    category:'Mammals',  parkLocation:'Yala National Park',      status:'Endangered',    emoji:'🐆', isFavorite:false },
  { id:'2', name:'Asian Elephant',        scientificName:'Elephas maximus',            category:'Mammals',  parkLocation:'Minneriya National Park',  status:'Endangered',    emoji:'🐘', isFavorite:false },
  { id:'3', name:'Sri Lankan Sloth Bear', scientificName:'Melursus ursinus inornatus', category:'Mammals',  parkLocation:'Wilpattu National Park',   status:'Vulnerable',    emoji:'🐻', isFavorite:false },
  { id:'4', name:'Peacock',               scientificName:'Pavo cristatus',             category:'Birds',    parkLocation:'Udawalawe National Park',  status:'Least Concern', emoji:'🦚', isFavorite:false },
  { id:'5', name:'Purple-faced Langur',   scientificName:'Trachypithecus vetulus',     category:'Mammals',  parkLocation:'Sinharaja Forest',         status:'Endangered',    emoji:'🐒', isFavorite:false },
  { id:'6', name:'Mugger Crocodile',      scientificName:'Crocodylus palustris',        category:'Reptiles', parkLocation:'Yala National Park',        status:'Vulnerable',    emoji:'🐊', isFavorite:false },
  { id:'7', name:'Sri Lanka Junglefowl',  scientificName:'Gallus lafayettii',           category:'Birds',    parkLocation:'Horton Plains',             status:'Least Concern', emoji:'🐓', isFavorite:false },
  { id:'8', name:'Indian Cobra',          scientificName:'Naja naja',                  category:'Reptiles', parkLocation:'Bundala National Park',    status:'Least Concern', emoji:'🐍', isFavorite:false },
];

async function seedAnimalData() {
  try {
    const count = await WildlifeAnimal.count();
    if (count === 0) {
      await WildlifeAnimal.bulkCreate(seedAnimals, { ignoreDuplicates: true });
      console.log('✅  Seeded 8 wildlife animals into wildlife_animal table');
    } else {
      console.log(`ℹ️   wildlife_animal already has ${count} animals — skipping seed`);
    }
  } catch (err) {
    console.error('❌  Animal seeder failed:', err.message);
    throw err;
  }
}

module.exports = seedAnimalData;
