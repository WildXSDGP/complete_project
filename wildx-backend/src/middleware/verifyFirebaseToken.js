// src/middleware/verifyFirebaseToken.js
let admin;
try {
  admin = require('firebase-admin');
} catch {
  admin = null;
}

const verifyFirebaseToken = async (req, res, next) => {
  if (!admin) {
    return res.status(503).json({ success: false, message: 'Firebase Admin not configured' });
  }
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer '))
      return res.status(401).json({ success: false, message: 'No token provided' });

    const token = authHeader.split('Bearer ')[1];
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ success: false, message: 'Invalid or expired token', error: err.message });
  }
};

module.exports = verifyFirebaseToken;
