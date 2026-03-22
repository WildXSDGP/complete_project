// src/routes/sosRoutes.js
const express = require('express');
const router  = express.Router();
const sos     = require('../controllers/sosController');
const emg     = require('../controllers/emergencyController');

// SOS Alerts
router.post('/alert',              sos.sendAlert);
router.get('/alerts',              sos.getAlerts);
router.patch('/alerts/:id/status', sos.updateAlertStatus);

module.exports = router;
