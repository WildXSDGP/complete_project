// src/routes/authRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/authController');

router.get('/health', ctrl.health);
router.post('/register', ctrl.register);
router.post('/login',    ctrl.login);
router.post('/refresh',  ctrl.refresh);
router.post('/logout',   ctrl.logout);
// Firebase
router.post('/firebase/register', ctrl.firebaseRegister);
router.post('/firebase/login',    ctrl.firebaseLogin);

module.exports = router;
