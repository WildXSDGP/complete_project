// server.js — WildX Backend v2
require('dotenv').config();

const express  = require('express');
const cors     = require('cors');
const helmet   = require('helmet');
const morgan   = require('morgan');

const errorHandler = require('./src/middleware/errorHandler');

// ── Routes ────────────────────────────────────────────────────
const authRoutes             = require('./src/routes/authRoutes');
const userRoutes             = require('./src/routes/userRoutes');
const firebaseUserRoutes     = require('./src/routes/firebaseUserRoutes');
const parkRoutes             = require('./src/routes/parkRoutes');
const sightingRoutes         = require('./src/routes/sightingRoutes');
const wildlifeSightingRoutes = require('./src/routes/wildlifeSightingRoutes');
const accommodationRoutes    = require('./src/routes/accommodationRoutes');
const bookingRoutes          = require('./src/routes/bookingRoutes');
const badgeRoutes            = require('./src/routes/badgeRoutes');
const parkVisitRoutes        = require('./src/routes/parkVisitRoutes');
const sosRoutes              = require('./src/routes/sosRoutes');
const emergencyRoutes        = require('./src/routes/emergencyRoutes');
const galleryRoutes          = require('./src/routes/galleryRoutes');
const notificationRoutes     = require('./src/routes/notificationRoutes');
const nationalParkRoutes     = require('./src/routes/nationalParkRoutes');
const markerRoutes           = require('./src/routes/markerRoutes');

const app  = express();
const PORT = process.env.PORT || 8080;

// ── Middleware ─────────────────────────────────────────────────
app.use(helmet());
app.use(cors({
  origin: (origin, callback) => callback(null, true), // Allow all origins
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-JWT'],
  credentials: true,
}));
// Handle preflight for all routes
app.options('*', cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
if (process.env.NODE_ENV !== 'test') app.use(morgan('dev'));

// ── Health check ───────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.status(200).json({ ok: true });
});

// ── API Routes ─────────────────────────────────────────────────
app.use('/api/auth',               authRoutes);
app.use('/api/users',              userRoutes);
app.use('/api/firebase-users',     firebaseUserRoutes);
app.use('/api/parks',              parkRoutes);
app.use('/api/sightings',          sightingRoutes);
app.use('/api/wildlife-sightings', wildlifeSightingRoutes);
app.use('/api/v1/accommodations',  accommodationRoutes);
app.use('/api/v1/bookings',        bookingRoutes);
app.use('/api/badges',             badgeRoutes);
app.use('/api/park-visits',        parkVisitRoutes);
app.use('/api/sos',                sosRoutes);
app.use('/api/emergency',          emergencyRoutes);
app.use('/api/v1',                 galleryRoutes);
app.use('/api/v1/notifications',   notificationRoutes);
app.use('/api/national-parks',     nationalParkRoutes);
app.use('/api/markers',            markerRoutes);

// ── 404 ────────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ success: false, error: `Route ${req.method} ${req.path} not found` });
});

app.use(errorHandler);

// Firebase Admin (optional)
try {
  const admin = require('firebase-admin');
  if (!admin.apps.length) {
    const fs = require('fs');
    const path = require('path');
    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n");

    if (projectId && clientEmail && privateKey) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          clientEmail,
          privateKey,
        }),
      });
      console.log('Firebase Admin initialized from environment variables');
    } else {
      const saPath = path.resolve(__dirname, 'firebase-service-account.json');
      if (fs.existsSync(saPath)) {
        admin.initializeApp({ credential: admin.credential.cert(require(saPath)) });
        console.log('Firebase Admin initialized from local service account');
      } else {
        console.log('Firebase Admin credentials not configured - skipping');
      }
    }
  }
} catch (e) {
  console.log('Firebase Admin not available:', e.message);
}

// Start Server ───────────────────────────────────────────────
app.listen(PORT, () => {
  console.log('\n──────────────────────────────────────────');
  console.log(`🚀  WildX API → http://localhost:${PORT}`);
  console.log(`❤️   Health   → http://localhost:${PORT}/health`);
  console.log('──────────────────────────────────────────\n');
});

process.on('SIGTERM', () => process.exit(0));
process.on('SIGINT',  () => process.exit(0));

module.exports = app;
