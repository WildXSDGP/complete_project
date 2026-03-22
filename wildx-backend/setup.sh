#!/bin/bash
echo "=========================================="
echo "  WildX Backend - Auto Setup"
echo "=========================================="
echo ""

echo "[1/4] Installing dependencies..."
npm install

echo ""
echo "[2/4] Creating database tables..."
node src/db/migrate.js

echo ""
echo "[3/4] Setting up Prisma tables..."
npx prisma db push --accept-data-loss

echo ""
echo "[4/4] Seeding initial data..."
node src/db/seed.js

echo ""
echo "=========================================="
echo "  Setup Complete! Starting server..."
echo "=========================================="
echo ""
npm run dev
