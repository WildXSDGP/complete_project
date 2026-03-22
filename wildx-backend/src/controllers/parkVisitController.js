// src/controllers/parkVisitController.js
const { query } = require('../config/db');

exports.getByUser = async (req, res, next) => {
  try {
    const result = await query(
      'SELECT * FROM park_visits WHERE user_id = $1 ORDER BY visit_count DESC', [req.params.user_id]
    );
    res.json({ success: true, count: result.rows.length, data: result.rows });
  } catch (err) { next(err); }
};

exports.create = async (req, res, next) => {
  try {
    const { user_id, park_name, visit_count } = req.body;
    if (!user_id || !park_name)
      return res.status(400).json({ success: false, error: 'user_id and park_name are required' });
    const result = await query(
      'INSERT INTO park_visits (user_id, park_name, visit_count, last_visited) VALUES ($1,$2,$3,NOW()) RETURNING *',
      [user_id, park_name, visit_count || 1]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) { next(err); }
};

exports.incrementVisit = async (req, res, next) => {
  try {
    const result = await query(
      'UPDATE park_visits SET visit_count = visit_count + 1, last_visited = NOW() WHERE id = $1 RETURNING *',
      [req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Park record not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) { next(err); }
};

exports.update = async (req, res, next) => {
  try {
    const { park_name, visit_count } = req.body;
    const result = await query(
      `UPDATE park_visits SET park_name = COALESCE($1, park_name), visit_count = COALESCE($2, visit_count)
       WHERE id = $3 RETURNING *`,
      [park_name, visit_count, req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Park record not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    const result = await query('DELETE FROM park_visits WHERE id = $1 RETURNING id', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Park record not found' });
    res.json({ success: true, message: 'Park record deleted successfully' });
  } catch (err) { next(err); }
};
