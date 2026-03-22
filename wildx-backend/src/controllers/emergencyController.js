// src/controllers/emergencyController.js
const sql = require('../config/neon');

// ─── Emergency Contacts ───────────────────────────────────────

exports.getContacts = async (req, res) => {
  try {
    const contacts = await sql`SELECT * FROM emergency_contacts WHERE is_active = TRUE ORDER BY priority ASC`;
    res.json({ success: true, data: contacts });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.createContact = async (req, res) => {
  try {
    const { name, number, emoji = '📞', category = 'other', priority = 0 } = req.body;
    if (!name || !number) return res.status(400).json({ success: false, message: 'name and number are required' });
    const result = await sql`
      INSERT INTO emergency_contacts (name, number, emoji, category, priority)
      VALUES (${name}, ${number}, ${emoji}, ${category}, ${priority}) RETURNING *
    `;
    res.status(201).json({ success: true, data: result[0] });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.updateContact = async (req, res) => {
  try {
    const { name, number, emoji, category, priority, is_active } = req.body;
    const result = await sql`
      UPDATE emergency_contacts SET
        name      = COALESCE(${name},      name),
        number    = COALESCE(${number},    number),
        emoji     = COALESCE(${emoji},     emoji),
        category  = COALESCE(${category},  category),
        priority  = COALESCE(${priority},  priority),
        is_active = COALESCE(${is_active}, is_active),
        updated_at = NOW()
      WHERE id = ${req.params.id} RETURNING *
    `;
    if (!result.length) return res.status(404).json({ success: false, message: 'Contact not found' });
    res.json({ success: true, data: result[0] });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.deleteContact = async (req, res) => {
  try {
    const result = await sql`
      UPDATE emergency_contacts SET is_active = FALSE, updated_at = NOW()
      WHERE id = ${req.params.id} RETURNING id
    `;
    if (!result.length) return res.status(404).json({ success: false, message: 'Contact not found' });
    res.json({ success: true, message: 'Contact deactivated' });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

// ─── Safety Tips ──────────────────────────────────────────────

exports.getTips = async (req, res) => {
  try {
    const { category } = req.query;
    const tips = category
      ? await sql`SELECT * FROM safety_tips WHERE is_active = TRUE AND category = ${category} ORDER BY sort_order ASC`
      : await sql`SELECT * FROM safety_tips WHERE is_active = TRUE ORDER BY sort_order ASC`;
    res.json({ success: true, data: tips });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.createTip = async (req, res) => {
  try {
    const { tip, category = 'wildlife', sort_order = 0 } = req.body;
    if (!tip) return res.status(400).json({ success: false, message: 'tip is required' });
    const result = await sql`
      INSERT INTO safety_tips (tip, category, sort_order) VALUES (${tip}, ${category}, ${sort_order}) RETURNING *
    `;
    res.status(201).json({ success: true, data: result[0] });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.deleteTip = async (req, res) => {
  try {
    const result = await sql`UPDATE safety_tips SET is_active = FALSE WHERE id = ${req.params.id} RETURNING id`;
    if (!result.length) return res.status(404).json({ success: false, message: 'Tip not found' });
    res.json({ success: true, message: 'Tip deactivated' });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

// ─── Location ─────────────────────────────────────────────────

exports.updateLocation = async (req, res) => {
  try {
    const { userId = 'anonymous', deviceId = '', latitude, longitude, parkName = '', block = '', accuracy = 0 } = req.body;
    if (!latitude || !longitude) return res.status(400).json({ success: false, message: 'latitude and longitude are required' });
    const result = await sql`
      INSERT INTO user_locations (user_id, device_id, latitude, longitude, park_name, block, accuracy)
      VALUES (${userId}, ${deviceId}, ${latitude}, ${longitude}, ${parkName}, ${block}, ${accuracy}) RETURNING *
    `;
    res.status(201).json({ success: true, message: 'Location saved', data: result[0] });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.getLocationHistory = async (req, res) => {
  try {
    const locations = await sql`
      SELECT * FROM user_locations WHERE user_id = ${req.params.userId} ORDER BY created_at DESC LIMIT 10
    `;
    res.json({ success: true, data: locations });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};
