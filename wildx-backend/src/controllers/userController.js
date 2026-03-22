// src/controllers/userController.js
// Table: users(id, firebase_uid, email, phone_number, display_name, photo_url,
//              auth_provider, is_active, created_at, last_login_at)
const { query } = require('../config/db');

// GET /api/users/:firebaseUid
exports.getUser = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM users WHERE firebase_uid=$1', [req.params.firebaseUid]);
    if (!r.rows.length) return res.status(404).json({ error: 'User not found' });
    return res.json({ success: true, user: r.rows[0] });
  } catch (err) { next(err); }
};

// PUT /api/users/:firebaseUid
exports.updateUser = async (req, res, next) => {
  try {
    const { displayName, photoUrl, phoneNumber } = req.body;
    const r = await query(
      `UPDATE users SET
         display_name = COALESCE($1, display_name),
         photo_url    = COALESCE($2, photo_url),
         phone_number = COALESCE($3, phone_number)
       WHERE firebase_uid=$4
       RETURNING *`,
      [displayName||null, photoUrl||null, phoneNumber||null, req.params.firebaseUid]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'User not found' });
    return res.json({ success: true, user: r.rows[0] });
  } catch (err) { next(err); }
};

// GET /api/users  (admin — all users)
exports.getAllUsers = async (req, res, next) => {
  try {
    const r = await query('SELECT id, firebase_uid, email, display_name, auth_provider, is_active, created_at FROM users ORDER BY created_at DESC');
    return res.json({ success: true, users: r.rows });
  } catch (err) { next(err); }
};

// ── Firebase user aliases ─────────────────────────────────────
exports.getFirebaseUser = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM users WHERE firebase_uid=$1', [req.params.firebaseUid]);
    if (!r.rows.length) return res.status(404).json({ error: 'User not found' });
    return res.json({ success: true, user: r.rows[0] });
  } catch (err) { next(err); }
};

exports.deleteFirebaseUser = async (req, res, next) => {
  try {
    await query('UPDATE users SET is_active=false WHERE firebase_uid=$1', [req.params.firebaseUid]);
    return res.json({ success: true });
  } catch (err) { next(err); }
};
