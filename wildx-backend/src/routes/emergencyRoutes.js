// src/routes/emergencyRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/emergencyController');

// Emergency contacts
router.get('/contacts',              ctrl.getContacts);
router.post('/contacts',             ctrl.createContact);
router.put('/contacts/:id',          ctrl.updateContact);
router.delete('/contacts/:id',       ctrl.deleteContact);

// Safety tips
router.get('/safety-tips',           ctrl.getTips);
router.post('/safety-tips',          ctrl.createTip);
router.delete('/safety-tips/:id',    ctrl.deleteTip);

// Location sharing
router.post('/location/update',          ctrl.updateLocation);
router.get('/location/history/:userId',  ctrl.getLocationHistory);

module.exports = router;
