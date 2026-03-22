// src/models/WildlifeAnimal.js
const { DataTypes } = require('sequelize');
const sequelize     = require('../config/database');

const WildlifeAnimal = sequelize.define('WildlifeAnimal', {
  id:             { type: DataTypes.STRING(10), primaryKey: true, allowNull: false },
  name:           { type: DataTypes.STRING(100), allowNull: false },
  scientificName: { type: DataTypes.STRING(150), allowNull: false, field: 'scientific_name' },
  category:       { type: DataTypes.STRING(50),  allowNull: false },
  parkLocation:   { type: DataTypes.STRING(150), allowNull: false, field: 'park_location' },
  status:         { type: DataTypes.STRING(50),  allowNull: false },
  emoji:          { type: DataTypes.STRING(10),  allowNull: false },
  isFavorite:     { type: DataTypes.BOOLEAN, defaultValue: false, field: 'is_favorite' },
}, { tableName: 'wildlife_animal', timestamps: false });

module.exports = WildlifeAnimal;
