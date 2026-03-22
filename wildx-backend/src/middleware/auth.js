// src/middleware/auth.js — JWT-based auth middleware
const jwt = require('jsonwebtoken');
const { AppError, ErrorCodes } = require('../utils/errors');
require('dotenv').config();

// Strict — blocks if no token
const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer '))
      throw new AppError(ErrorCodes.UNAUTHORIZED.code, 'Authentication required', 401);

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { userId: decoded.userId || decoded.id, id: decoded.userId || decoded.id, email: decoded.email };
    next();
  } catch (error) {
    if (error instanceof AppError) return next(error);
    if (error.name === 'TokenExpiredError')
      return next(new AppError(ErrorCodes.TOKEN_EXPIRED.code, 'Token has expired', 401));
    return next(new AppError(ErrorCodes.INVALID_TOKEN.code, 'Invalid token', 401));
  }
};

// Optional — continues even without token
const optionalAuth = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) return next();
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { userId: decoded.userId || decoded.id, id: decoded.userId || decoded.id, email: decoded.email };
    next();
  } catch {
    next();
  }
};

module.exports = { authenticate, optionalAuth };
