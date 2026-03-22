// src/routes/notificationRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/notificationController');

// Static named routes MUST come before /:id
router.get('/unread-count',       ctrl.getUnreadCount);
router.patch('/read-all',         ctrl.markAllAsRead);
router.delete('/delete-all',      ctrl.deleteAllNotifications);

router.get('/',                   ctrl.getAllNotifications);
router.post('/',                  ctrl.createNotification);
router.get('/:id',                ctrl.getNotificationById);
router.patch('/:id/read',         ctrl.markAsRead);
router.delete('/:id',             ctrl.deleteNotification);

module.exports = router;
