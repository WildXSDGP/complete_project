// prisma/seed.js — Seeds Prisma-managed tables (accommodations, bookings)
// Run: npm run prisma:seed

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const parks = [
  { id: 'park_yala',      name: 'Yala National Park',      description: 'Sri Lanka\'s most famous national park, known for one of the highest leopard densities in the world.' },
  { id: 'park_wilpattu',  name: 'Wilpattu National Park',  description: 'The largest national park in Sri Lanka, featuring unique natural lakes called "villus".' },
  { id: 'park_udawalawe', name: 'Udawalawe National Park',  description: 'Home to a large population of elephants and the Elephant Transit Home sanctuary.' },
];

const accommodations = [
  {
    id: 'acc_001', name: 'Green Valley Eco-Lodge', parkId: 'park_yala',
    pricePerNight: 9500, distanceFromGate: 4.0, travelTime: '20 mins', fuelStops: 1,
    rating: 4.9, isEcoFriendly: true, isFamilyFriendly: true, hasJeepHire: true,
    description: 'A serene eco-lodge nestled in the heart of Yala.',
    images: [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
    ],
  },
  {
    id: 'acc_002', name: 'Yala Safari Lodge', parkId: 'park_yala',
    pricePerNight: 8500, distanceFromGate: 2.5, travelTime: '12 mins', fuelStops: 1,
    rating: 4.7, isEcoFriendly: true, isFamilyFriendly: false, hasJeepHire: false,
    description: 'An intimate safari camp just minutes from the main gate.',
    images: [
      'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
    ],
  },
  {
    id: 'acc_003', name: 'Wilpattu Forest Camp', parkId: 'park_wilpattu',
    pricePerNight: 6200, distanceFromGate: 1.2, travelTime: '10 mins', fuelStops: 0,
    rating: 4.5, isEcoFriendly: false, isFamilyFriendly: false, hasJeepHire: false,
    description: 'A rustic tented camp on the edge of Wilpattu.',
    images: [
      'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800',
    ],
  },
  {
    id: 'acc_004', name: 'Udawalawe Family Resort', parkId: 'park_udawalawe',
    pricePerNight: 12000, distanceFromGate: 7.8, travelTime: '25 mins', fuelStops: 2,
    rating: 4.6, isEcoFriendly: false, isFamilyFriendly: true, hasJeepHire: true,
    description: 'A spacious family resort near Udawalawe.',
    images: [
      'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
    ],
  },
];

async function main() {
  console.log('🌱 Seeding Prisma tables...\n');

  await prisma.booking.deleteMany();
  await prisma.refreshToken.deleteMany();
  await prisma.authUser.deleteMany();
  await prisma.accommodationImage.deleteMany();
  await prisma.accommodation.deleteMany();
  await prisma.park.deleteMany();

  for (const park of parks) {
    await prisma.park.create({ data: park });
    console.log(`  ✓ Park: ${park.name}`);
  }

  for (const acc of accommodations) {
    const { images, ...data } = acc;
    await prisma.accommodation.create({
      data: { ...data, images: { create: images.map((url, i) => ({ imageUrl: url, sortOrder: i })) } },
    });
    console.log(`  ✓ Accommodation: ${acc.name}`);
  }

  console.log('\n✅ Prisma seed complete!');
}

main().catch((e) => { console.error('❌ Seed failed:', e); process.exit(1); })
      .finally(() => prisma.$disconnect());
