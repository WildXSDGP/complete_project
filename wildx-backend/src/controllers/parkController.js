// src/controllers/parkController.js
const { query } = require('../config/db');

exports.getAll = async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM parks ORDER BY is_featured DESC, id ASC');
    res.json(result.rows);
  } catch (err) { next(err); }
};

exports.getFeatured = async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM parks WHERE is_featured = TRUE LIMIT 1');
    if (!result.rows.length) return res.status(404).json({ error: 'No featured park found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
};

exports.getById = async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM parks WHERE id = $1', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ error: 'Park not found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
};

exports.create = async (req, res, next) => {
  try {
    const { name, location, image_url, description, animal_count, is_featured } = req.body;
    const result = await query(
      `INSERT INTO parks (name, location, image_url, description, animal_count, is_featured)
       VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`,
      [name, location, image_url, description, animal_count || 0, is_featured || false]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) { next(err); }
};

exports.update = async (req, res, next) => {
  try {
    const { name, location, image_url, description, animal_count, is_featured } = req.body;
    const result = await query(
      `UPDATE parks SET name=$1, location=$2, image_url=$3, description=$4,
       animal_count=$5, is_featured=$6 WHERE id=$7 RETURNING *`,
      [name, location, image_url, description, animal_count, is_featured, req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Park not found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    const result = await query('DELETE FROM parks WHERE id = $1 RETURNING id', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ error: 'Park not found' });
    res.json({ message: 'Park deleted' });
  } catch (err) { next(err); }
};
