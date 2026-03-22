// src/controllers/badgeController.js
const { query } = require('../config/db');

exports.getByUser = async (req, res, next) => {
  try {
    const badges = await query('SELECT * FROM badges WHERE user_id = $1 ORDER BY id ASC', [req.params.user_id]);
    res.json({ success: true, count: badges.rows.length, data: badges.rows });
  } catch (err) { next(err); }
};

exports.create = async (req, res, next) => {
  try {
    const { user_id, title, icon_asset, earned } = req.body;
    if (!user_id || !title || !icon_asset)
      return res.status(400).json({ success: false, error: 'user_id, title, and icon_asset are required' });
    const result = await query(
      `INSERT INTO badges (user_id, title, icon_asset, earned, earned_at)
       VALUES ($1,$2,$3,$4,$5) RETURNING *`,
      [user_id, title, icon_asset, !!earned, earned ? new Date() : null]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) { next(err); }
};

exports.markEarned = async (req, res, next) => {
  try {
    const result = await query(
      'UPDATE badges SET earned = TRUE, earned_at = NOW() WHERE id = $1 RETURNING *', [req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Badge not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    const result = await query('DELETE FROM badges WHERE id = $1 RETURNING id', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Badge not found' });
    res.json({ success: true, message: 'Badge deleted successfully' });
  } catch (err) { next(err); }
};
