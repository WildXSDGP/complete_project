// notificationController.js — pg direct (notifications table)
const { query } = require('../config/db');

// GET /api/v1/notifications
exports.getAll = async (req, res) => {
  try {
    const r = await query('SELECT * FROM notifications ORDER BY created_at DESC LIMIT 50');
    res.json({ success: true, data: r.rows.map(n => ({
      id: n.id, title: n.title, body: n.body,
      type: n.type, isRead: n.is_read, createdAt: n.created_at,
    }))});
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

// GET /api/v1/notifications/unread-count
exports.getUnreadCount = async (req, res) => {
  try {
    const r = await query('SELECT COUNT(*) FROM notifications WHERE is_read = false');
    res.json({ success: true, count: parseInt(r.rows[0].count) });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

// PATCH /api/v1/notifications/read-all
exports.markAllRead = async (req, res) => {
  try {
    await query('UPDATE notifications SET is_read = true');
    res.json({ success: true, message: 'All notifications marked as read' });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

// PATCH /api/v1/notifications/:id/read
exports.markRead = async (req, res) => {
  try {
    await query('UPDATE notifications SET is_read = true WHERE id = $1', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

// ── Aliases ──────────────────────────────────────────────────
exports.getAllNotifications    = exports.getAll;
exports.markAllAsRead          = exports.markAllRead;
exports.deleteAllNotifications = async (req, res) => {
  try {
    await query('DELETE FROM notifications');
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.createNotification = async (req, res) => {
  try {
    const { title, body, type = 'general', userId } = req.body;
    if (!title || !body) return res.status(400).json({ error: 'title and body required' });
    const r = await query(
      'INSERT INTO notifications (title, body, type, user_id) VALUES ($1,$2,$3,$4) RETURNING *',
      [title, body, type, userId || null]
    );
    res.status(201).json({ success: true, data: r.rows[0] });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.getNotificationById = async (req, res) => {
  try {
    const r = await query('SELECT * FROM notifications WHERE id=$1', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ error: 'Not found' });
    res.json({ success: true, data: r.rows[0] });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.deleteNotification = async (req, res) => {
  try {
    await query('DELETE FROM notifications WHERE id=$1', [req.params.id]);
    res.json({ success: true });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.markAsRead = exports.markRead;
