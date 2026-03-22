// src/routes/wildlifeSightingRoutes.js
const express  = require('express');
const { body } = require('express-validator');
const router   = express.Router();
const ctrl     = require('../controllers/sightingController');

const createRules = [
  body('animalType')   .notEmpty().withMessage('animalType is required'),
  body('locationName') .notEmpty().withMessage('locationName is required'),
  body('latitude')     .isFloat({ min: -90,  max: 90  }).withMessage('Invalid latitude'),
  body('longitude')    .isFloat({ min: -180, max: 180 }).withMessage('Invalid longitude'),
];

router.get('/',             ctrl.getAllAdvanced);
router.get('/stats',        ctrl.getStats);
router.get('/:id',          ctrl.getAdvancedById);
router.post('/', createRules, ctrl.createAdvanced);
router.put('/:id/status',   ctrl.updateStatus);
router.delete('/:id',       ctrl.deleteAdvanced);

module.exports = router;
