// src/routes/accommodationRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/accommodationController');
const { authenticate, optionalAuth } = require('../middleware/auth');

// Accommodations
router.get('/',                      ctrl.getAll);
router.get('/:id',                   ctrl.getById);
router.get('/:id/availability',      ctrl.checkAvailability);

module.exports = router;
