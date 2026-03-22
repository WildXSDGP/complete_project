// src/models/WildlifePhoto.js
const { DataTypes } = require('sequelize');
const sequelize     = require('../config/database');

const WildlifePhoto = sequelize.define('WildlifePhoto', {
  id:         { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  imageUrl:   { type: DataTypes.TEXT,        allowNull: false, field: 'image_url' },
  animalType: { type: DataTypes.STRING(100), allowNull: false, field: 'animal_type' },
  parkName:   { type: DataTypes.STRING(150), allowNull: false, field: 'park_name' },
  uploadedBy: { type: DataTypes.STRING(100), allowNull: false, field: 'uploaded_by' },
  uploadedAt: { type: DataTypes.DATE,        defaultValue: DataTypes.NOW, field: 'uploaded_at' },
}, { tableName: 'wildlife_photos', timestamps: false });

module.exports = WildlifePhoto;
