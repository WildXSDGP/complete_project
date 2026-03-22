// Prisma client — graceful fallback if not generated
let prisma;
try {
  const { PrismaClient } = require('@prisma/client');
  prisma = new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['error', 'warn'] : ['error'],
  });
} catch (e) {
  // Prisma not generated — return a stub that won't crash the server
  console.log('ℹ️  Prisma not available — accommodation/booking uses pg directly');
  prisma = {
    accommodation: { findMany: async () => [], findUnique: async () => null },
    booking:       { findMany: async () => [], findUnique: async () => null, create: async () => null },
    refreshToken:  { create: async () => null, findFirst: async () => null, delete: async () => null },
    $connect:      async () => {},
    $disconnect:   async () => {},
  };
}

module.exports = prisma;
