const { query } = require('../config/db');

exports.syncUser = async (req, res, next) => {
  try {
    const { firebaseUid, email, phoneNumber, displayName, photoUrl, authProvider } = req.body;
    if (!firebaseUid) return res.status(400).json({ error: 'firebaseUid required' });
    const r = await query(
      `INSERT INTO users (firebase_uid, email, phone_number, display_name, photo_url, auth_provider, is_active, created_at, last_login_at)
       VALUES ($1,$2,$3,$4,$5,$6,true,NOW(),NOW())
       ON CONFLICT (firebase_uid) DO UPDATE SET last_login_at=NOW(),
         email=COALESCE(EXCLUDED.email,users.email),
         display_name=COALESCE(EXCLUDED.display_name,users.display_name),
         photo_url=COALESCE(EXCLUDED.photo_url,users.photo_url)
       RETURNING *`,
      [firebaseUid, email||null, phoneNumber||null, displayName||null, photoUrl||null, authProvider||'email']
    );
    return res.json({ success: true, user: r.rows[0] });
  } catch (err) { next(err); }
};

exports.getUser = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM users WHERE firebase_uid=$1', [req.params.firebaseUid]);
    if (!r.rows.length) return res.status(404).json({ error: 'Not found' });
    return res.json({ success: true, user: r.rows[0] });
  } catch (err) { next(err); }
};
