// src/controllers/sightingController.js
// Tables:
//   sightings(id TEXT, animal_type_id, animal_type_name, animal_type_emoji,
//             animal_category ENUM, location_name, latitude, longitude,
//             photo_url, notes, sighting_time TIMESTAMPTZ, status ENUM,
//             created_at, updated_at)
//
//   sighting_reports(id BIGINT, flutter_report_id, animal_type_id, animal_type_name,
//             animal_category, location_name, latitude, longitude,
//             is_current_location, photo_path, notes, status, sighting_time,
//             created_at, updated_at)

const { query } = require('../config/db');

// ── sightings table ───────────────────────────────────────────

// GET /api/sightings
exports.getAllSightings = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM sightings ORDER BY sighting_time DESC LIMIT 100');
    return res.json({ success: true, sightings: r.rows });
  } catch (err) { next(err); }
};

// GET /api/sightings/:id
exports.getSightingById = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM sightings WHERE id=$1', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ error: 'Sighting not found' });
    return res.json({ success: true, sighting: r.rows[0] });
  } catch (err) { next(err); }
};

// POST /api/sightings
exports.createSighting = async (req, res, next) => {
  try {
    const {
      id, animalTypeId, animalTypeName, animalTypeEmoji,
      animalCategory, locationName, latitude, longitude,
      photoUrl, notes, sightingTime, status
    } = req.body;

    const r = await query(
      `INSERT INTO sightings
         (id, animal_type_id, animal_type_name, animal_type_emoji, animal_category,
          location_name, latitude, longitude, photo_url, notes, sighting_time, status,
          created_at, updated_at)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,NOW(),NOW())
       RETURNING *`,
      [
        id || `s_${Date.now()}`,
        animalTypeId || null,
        animalTypeName,
        animalTypeEmoji || null,
        animalCategory || 'MAMMAL',
        locationName,
        latitude,
        longitude,
        photoUrl || null,
        notes || null,
        sightingTime || new Date().toISOString(),
        status || 'PENDING',
      ]
    );
    return res.status(201).json({ success: true, sighting: r.rows[0] });
  } catch (err) { next(err); }
};

// ── sighting_reports table ────────────────────────────────────

// GET /api/sighting-reports
exports.getAllReports = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM sighting_reports ORDER BY sighting_time DESC LIMIT 100');
    return res.json({ success: true, reports: r.rows });
  } catch (err) { next(err); }
};

// POST /api/sighting-reports
exports.createReport = async (req, res, next) => {
  try {
    const {
      flutterReportId, animalTypeId, animalTypeName, animalCategory,
      locationName, latitude, longitude, isCurrentLocation,
      photoPath, notes, sightingTime, status
    } = req.body;

    const r = await query(
      `INSERT INTO sighting_reports
         (flutter_report_id, animal_type_id, animal_type_name, animal_category,
          location_name, latitude, longitude, is_current_location,
          photo_path, notes, sighting_time, status, created_at, updated_at)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,NOW(),NOW())
       RETURNING *`,
      [
        flutterReportId || null,
        animalTypeId,
        animalTypeName,
        animalCategory || null,
        locationName,
        latitude,
        longitude,
        isCurrentLocation || false,
        photoPath || null,
        notes || null,
        sightingTime || new Date().toISOString(),
        status || 'SUBMITTED',
      ]
    );
    return res.status(201).json({ success: true, report: r.rows[0] });
  } catch (err) { next(err); }
};

// GET /api/sighting-reports/:id
exports.getReportById = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM sighting_reports WHERE id=$1', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ error: 'Report not found' });
    return res.json({ success: true, report: r.rows[0] });
  } catch (err) { next(err); }
};

// ── Aliases ──────────────────────────────────────────────────
exports.getRecent  = exports.getAllSightings;
exports.getMy      = exports.getAllSightings;
exports.getById    = exports.getSightingById;
exports.create     = exports.createSighting;

exports.update = async (req, res, next) => {
  try {
    const r = await query(
      `UPDATE sightings SET status=$1, updated_at=NOW() WHERE id=$2 RETURNING *`,
      [req.body.status || 'PENDING', req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'Not found' });
    return res.json({ success: true, sighting: r.rows[0] });
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    await query('DELETE FROM sightings WHERE id=$1', [req.params.id]);
    return res.json({ success: true });
  } catch (err) { next(err); }
};

// ── Wildlife Sighting advanced methods ────────────────────────
exports.getAllAdvanced = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM sightings ORDER BY sighting_time DESC LIMIT 100');
    return res.json({ success: true, sightings: r.rows });
  } catch (err) { next(err); }
};

exports.getStats = async (req, res, next) => {
  try {
    const r = await query(`
      SELECT animal_category, COUNT(*) as count
      FROM sightings GROUP BY animal_category ORDER BY count DESC
    `);
    const total = await query('SELECT COUNT(*) as total FROM sightings');
    return res.json({ success: true, total: parseInt(total.rows[0].total), byCategory: r.rows });
  } catch (err) { next(err); }
};

exports.getAdvancedById = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM sightings WHERE id=$1', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ error: 'Not found' });
    return res.json({ success: true, sighting: r.rows[0] });
  } catch (err) { next(err); }
};

exports.createAdvanced = async (req, res, next) => {
  try {
    const { animalType, locationName, latitude, longitude, notes, photoUrl, status } = req.body;
    const r = await query(
      `INSERT INTO sightings (id, animal_type_name, location_name, latitude, longitude,
       notes, photo_url, sighting_time, status, created_at, updated_at)
       VALUES ($1,$2,$3,$4,$5,$6,$7,NOW(),$8,NOW(),NOW()) RETURNING *`,
      [`s_${Date.now()}`, animalType, locationName, latitude, longitude,
       notes||null, photoUrl||null, status||'PENDING']
    );
    return res.status(201).json({ success: true, sighting: r.rows[0] });
  } catch (err) { next(err); }
};

exports.updateStatus = async (req, res, next) => {
  try {
    const r = await query(
      'UPDATE sightings SET status=$1, updated_at=NOW() WHERE id=$2 RETURNING *',
      [req.body.status, req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ error: 'Not found' });
    return res.json({ success: true, sighting: r.rows[0] });
  } catch (err) { next(err); }
};

exports.deleteAdvanced = async (req, res, next) => {
  try {
    await query('DELETE FROM sightings WHERE id=$1', [req.params.id]);
    return res.json({ success: true });
  } catch (err) { next(err); }
};
