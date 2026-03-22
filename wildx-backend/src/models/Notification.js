// src/models/Notification.js
const { DataTypes } = require('sequelize');
const sequelize     = require('../config/database');

const Notification = sequelize.define('Notification', {
  id:         { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  userId:     { type: DataTypes.STRING(100), field: 'user_id' },
  type:       { type: DataTypes.STRING(50), allowNull: false, defaultValue: 'system',
                validate: { isIn: [['sighting','conservation','photo','park','system','welcome']] } },
  title:      { type: DataTypes.STRING(200), allowNull: false },
  message:    { type: DataTypes.TEXT, allowNull: false },
  iconEmoji:  { type: DataTypes.STRING(10),  defaultValue: '🔔', field: 'icon_emoji' },
  colorHex:   { type: DataTypes.STRING(7),   defaultValue: '#2ECC71', field: 'color_hex' },
  bgColorHex: { type: DataTypes.STRING(7),   defaultValue: '#E8F5E9', field: 'bg_color_hex' },
  actionData: { type: DataTypes.TEXT, field: 'action_data' },
  isRead:     { type: DataTypes.BOOLEAN, defaultValue: false, field: 'is_read' },
  createdAt:  { type: DataTypes.DATE, defaultValue: DataTypes.NOW, field: 'created_at' },
  isDeleted:  { type: DataTypes.BOOLEAN, defaultValue: false, field: 'is_deleted' },
}, { tableName: 'notifications', timestamps: false });

module.exports = Notification;
