// src/seeders/notificationSeeder.js
const Notification = require('../models/Notification');

const sampleNotifications = [
  {
    userId: null, type: 'welcome', title: 'Welcome to WildX! 👋',
    message: "Start exploring Sri Lanka's incredible wildlife. Browse the gallery and share your sightings.",
    iconEmoji: '👋', colorHex: '#00C7BE', bgColorHex: '#E0F7F6',
    isRead: false, createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 7),
  },
  {
    userId: null, type: 'sighting', title: 'New Leopard Sighting in Yala! 🐆',
    message: 'A Sri Lankan Leopard was spotted near the water hole. Rangers confirmed two cubs were also seen.',
    iconEmoji: '🐆', colorHex: '#2ECC71', bgColorHex: '#E8F5E9',
    actionData: JSON.stringify({ animalId: '1', parkName: 'Yala National Park' }),
    isRead: false, createdAt: new Date(Date.now() - 1000 * 60 * 30),
  },
  {
    userId: null, type: 'conservation', title: 'Conservation Alert: Purple-faced Langur',
    message: 'Population in Sinharaja has declined by 12%. Support conservation efforts to protect them.',
    iconEmoji: '⚠️', colorHex: '#E53935', bgColorHex: '#FFEBEE',
    actionData: JSON.stringify({ animalId: '5' }),
    isRead: false, createdAt: new Date(Date.now() - 1000 * 60 * 60 * 2),
  },
  {
    userId: null, type: 'park', title: 'Minneriya — Elephant Gathering Season 🐘',
    message: 'Over 300 elephants expected near the tank. Best viewing: 3pm–6pm daily.',
    iconEmoji: '🐘', colorHex: '#FF9500', bgColorHex: '#FFF3E0',
    actionData: JSON.stringify({ parkName: 'Minneriya National Park' }),
    isRead: false, createdAt: new Date(Date.now() - 1000 * 60 * 60 * 12),
  },
  {
    userId: null, type: 'system', title: 'WildX v2.0 is Live!',
    message: 'Full unified backend is now available with all features merged. More species coming soon!',
    iconEmoji: '🚀', colorHex: '#5856D6', bgColorHex: '#EEF0FF',
    isRead: true, createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 3),
  },
];

async function seedNotificationData() {
  try {
    const count = await Notification.count();
    if (count === 0) {
      await Notification.bulkCreate(sampleNotifications, { ignoreDuplicates: true });
      console.log(`✅  Seeded ${sampleNotifications.length} sample notifications`);
    } else {
      console.log(`ℹ️   notifications table already has ${count} records — skipping seed`);
    }
  } catch (err) {
    console.error('❌  Notification seeder failed:', err.message);
    throw err;
  }
}

module.exports = seedNotificationData;
