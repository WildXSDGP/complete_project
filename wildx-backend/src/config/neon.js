// src/config/neon.js — Neon serverless SQL client (SOS module)
const { neon } = require('@neondatabase/serverless');
require('dotenv').config();

if (!process.env.DATABASE_URL) {
  console.error('❌  DATABASE_URL is not set');
  process.exit(1);
}

const sql = neon(process.env.DATABASE_URL);
module.exports = sql;
