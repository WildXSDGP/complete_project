// src/routes/sightingRoutes.js
const express  = require('express');
const { body } = require('express-validator');
const router   = express.Router();
const ctrl     = require('../controllers/sightingController');
const { authenticate } = require('../middleware/auth');

// ── Simple sightings ─────────────────────────────────────────
router.get('/recent',    ctrl.getRecent);
router.get('/my',        authenticate, ctrl.getMy);
router.get('/:id',       ctrl.getById);
router.post('/',         authenticate, ctrl.create);
router.put('/:id',       authenticate, ctrl.update);
router.delete('/:id',    authenticate, ctrl.remove);

module.exports = router;
