// src/routes/galleryRoutes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/galleryController');

// Animals
router.get('/animals/categories',        ctrl.getCategories);
router.get('/animals/parks',             ctrl.getParks);
router.get('/animals/favorites',         ctrl.getFavorites);
router.get('/animals',                   ctrl.getAllAnimals);
router.get('/animals/:id',               ctrl.getAnimalById);
router.patch('/animals/:id/favorite',    ctrl.toggleFavorite);

// Photos
router.get('/photos',                    ctrl.getAllPhotos);
router.get('/photos/user/:uploadedBy',   ctrl.getPhotosByUser);
router.post('/photos',                   ctrl.uploadPhoto);
router.delete('/photos/:id',             ctrl.deletePhoto);

module.exports = router;
