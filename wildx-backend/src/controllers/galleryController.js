// galleryController.js — Uses pg directly (wildlife_animals, wildlife_photos tables)
const { query } = require('../config/db');

const getStatusColor   = (s) => s === 'Endangered' ? '#E53935' : s === 'Vulnerable' ? '#FF9800' : '#2ECC71';
const getStatusBgColor = (s) => s === 'Endangered' ? '#FFEBEE' : s === 'Vulnerable' ? '#FFF3E0' : '#E8F5E9';

// GET /api/v1/animals
exports.getAllAnimals = async (req, res) => {
  try {
    const { search, category, park } = req.query;
    let sql = 'SELECT * FROM wildlife_animals WHERE 1=1';
    const params = [];
    let i = 1;
    if (search?.trim()) {
      sql += ` AND (name ILIKE $${i} OR scientific_name ILIKE $${i} OR park_location ILIKE $${i})`;
      params.push(`%${search.trim()}%`); i++;
    }
    if (category && category !== 'All') { sql += ` AND category = $${i}`; params.push(category); i++; }
    if (park && park !== 'All')         { sql += ` AND park_location = $${i}`; params.push(park); i++; }
    sql += ' ORDER BY name ASC';

    const r = await query(sql, params);
    res.json(r.rows.map(a => ({
      id: a.id, name: a.name, scientificName: a.scientific_name,
      category: a.category, parkLocation: a.park_location,
      status: a.status, emoji: a.emoji, isFavorite: a.is_favorite,
      imageUrl: a.image_url || null,
      statusColor: getStatusColor(a.status), statusBgColor: getStatusBgColor(a.status),
    })));
  } catch (err) { res.status(500).json({ message: 'Error fetching animals: ' + err.message }); }
};

// GET /api/v1/animals/categories
exports.getCategories = async (req, res) => {
  try {
    const r = await query('SELECT DISTINCT category FROM wildlife_animals ORDER BY category');
    res.json(['All', ...r.rows.map(x => x.category)]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// GET /api/v1/animals/:id
exports.getAnimalById = async (req, res) => {
  try {
    const r = await query('SELECT * FROM wildlife_animals WHERE id = $1', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ message: 'Animal not found' });
    const a = r.rows[0];
    res.json({ id: a.id, name: a.name, scientificName: a.scientific_name,
      category: a.category, parkLocation: a.park_location, status: a.status,
      emoji: a.emoji, isFavorite: a.is_favorite,
      statusColor: getStatusColor(a.status), statusBgColor: getStatusBgColor(a.status) });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// PATCH /api/v1/animals/:id/favorite
exports.toggleFavorite = async (req, res) => {
  try {
    const r = await query(
      'UPDATE wildlife_animals SET is_favorite = NOT is_favorite WHERE id = $1 RETURNING *',
      [req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ message: 'Animal not found' });
    res.json({ isFavorite: r.rows[0].is_favorite });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// GET /api/v1/photos
exports.getAllPhotos = async (req, res) => {
  try {
    const r = await query('SELECT * FROM wildlife_photos ORDER BY uploaded_at DESC LIMIT 50');
    res.json(r.rows.map(p => ({
      id: p.id, imageUrl: p.image_url, animalType: p.animal_type,
      parkName: p.park_name, uploadedBy: p.uploaded_by, uploadedAt: p.uploaded_at,
    })));
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// POST /api/v1/photos
exports.uploadPhoto = async (req, res) => {
  try {
    const { imageUrl, animalType, parkName, uploadedBy = 'User' } = req.body;
    if (!imageUrl || !animalType || !parkName)
      return res.status(400).json({ message: 'imageUrl, animalType, parkName required' });
    const r = await query(
      'INSERT INTO wildlife_photos (image_url, animal_type, park_name, uploaded_by) VALUES ($1,$2,$3,$4) RETURNING *',
      [imageUrl, animalType, parkName, uploadedBy]
    );
    res.status(201).json({ id: r.rows[0].id, imageUrl, animalType, parkName });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// ── Missing aliases ───────────────────────────────────────────
exports.getParks = async (req, res) => {
  try {
    const r = await query('SELECT DISTINCT park_location AS name FROM wildlife_animals ORDER BY park_location');
    res.json(['All', ...r.rows.map(x => x.name)]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getFavorites = async (req, res) => {
  try {
    const r = await query('SELECT * FROM wildlife_animals WHERE is_favorite=true ORDER BY name');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getPhotosByUser = async (req, res) => {
  try {
    const r = await query('SELECT * FROM wildlife_photos WHERE uploaded_by=$1 ORDER BY uploaded_at DESC', [req.params.userId || 'User']);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.deletePhoto = async (req, res) => {
  try {
    await query('DELETE FROM wildlife_photos WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
