// src/routes/parkVisitRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/parkVisitController');

router.get('/user/:user_id', ctrl.getByUser);
router.post('/',             ctrl.create);
router.patch('/:id/visit',   ctrl.incrementVisit);
router.put('/:id',           ctrl.update);
router.delete('/:id',        ctrl.remove);

module.exports = router;
