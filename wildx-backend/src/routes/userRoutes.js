const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/userController');

router.get('/',              ctrl.getAllUsers);
router.get('/:firebaseUid',  ctrl.getUser);
router.put('/:firebaseUid',  ctrl.updateUser);

module.exports = router;
