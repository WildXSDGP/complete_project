// src/routes/firebaseUserRoutes.js
const express         = require('express');
const router          = express.Router();
const ctrl            = require('../controllers/userController');
const verifyFirebase  = require('../middleware/verifyFirebaseToken');

router.get('/',                       async (req, res, next) => {
  const { query } = require('../config/db');
  try {
    const r = await query('SELECT id, firebase_uid, email, display_name, photo_url, auth_provider, is_active, created_at, last_login_at FROM firebase_users ORDER BY created_at DESC');
    res.json({ success: true, count: r.rows.length, users: r.rows });
  } catch (err) { next(err); }
});
router.get('/:firebaseUid',           ctrl.getFirebaseUser);
router.delete('/:firebaseUid',        verifyFirebase, ctrl.deleteFirebaseUser);

module.exports = router;
