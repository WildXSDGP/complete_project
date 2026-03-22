// src/routes/badgeRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/badgeController');

router.get('/user/:user_id', ctrl.getByUser);
router.post('/',             ctrl.create);
router.patch('/:id/earn',    ctrl.markEarned);
router.delete('/:id',        ctrl.remove);

module.exports = router;
