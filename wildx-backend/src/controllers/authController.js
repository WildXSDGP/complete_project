// src/controllers/authController.js
// Matches exact DB: users(id, firebase_uid, email, phone_number,
//   display_name, photo_url, auth_provider, is_active, created_at, last_login_at)
const { query } = require('../config/db');

exports.health = (req, res) =>
  res.json({ status: 'UP', service: 'WildX Auth', ts: new Date() });

// POST /api/auth/firebase/login  ← Flutter calls this after every sign-in
exports.firebaseLogin = async (req, res, next) => {
  try {
    const { firebaseUid, email, phoneNumber, displayName, photoUrl, authProvider } = req.body;
    if (!firebaseUid)
      return res.status(400).json({ success: false, error: 'firebaseUid is required' });

    const result = await query(
      `INSERT INTO firebase_users
         (firebase_uid, email, phone_number, display_name, photo_url, auth_provider, is_active, created_at, last_login_at)
       VALUES ($1,$2,$3,$4,$5,$6,true,NOW(),NOW())
       ON CONFLICT (firebase_uid) DO UPDATE SET
         last_login_at = NOW(),
         email         = COALESCE(EXCLUDED.email,        firebase_users.email),
         display_name  = COALESCE(EXCLUDED.display_name, firebase_users.display_name),
         photo_url     = COALESCE(EXCLUDED.photo_url,    firebase_users.photo_url)
       RETURNING id, firebase_uid, email, phone_number, display_name, photo_url, auth_provider, is_active, created_at, last_login_at`,
      [firebaseUid, email||null, phoneNumber||null, displayName||null, photoUrl||null, authProvider||'email']
    );
    return res.status(200).json({ success: true, user: result.rows[0] });
  } catch (err) { next(err); }
};

exports.firebaseRegister = exports.firebaseLogin;
exports.register         = exports.firebaseLogin;

exports.login = async (req, res, next) => {
  try {
    const { firebaseUid } = req.body;
    if (!firebaseUid) return res.status(400).json({ error: 'firebaseUid required' });
    const r = await query('SELECT * FROM firebase_users WHERE firebase_uid=$1', [firebaseUid]);
    if (!r.rows.length) return res.status(404).json({ error: 'User not found' });
    await query('UPDATE firebase_users SET last_login_at=NOW() WHERE firebase_uid=$1', [firebaseUid]);
    return res.json({ success: true, user: r.rows[0] });
  } catch (err) { next(err); }
};

exports.logout  = (req, res) => res.json({ success: true, message: 'Logged out 🦁' });
exports.refresh = (req, res) => res.json({ success: true, message: 'Use Firebase token refresh on client.' });

