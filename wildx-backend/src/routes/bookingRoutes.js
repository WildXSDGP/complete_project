// src/routes/bookingRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/accommodationController');
const { authenticate, optionalAuth } = require('../middleware/auth');

router.post('/',               optionalAuth, ctrl.createBooking);
router.get('/',                authenticate, ctrl.getBookings);
router.get('/:bookingId',      authenticate, ctrl.getBookingById);
router.delete('/:bookingId',   authenticate, ctrl.cancelBooking);

module.exports = router;
