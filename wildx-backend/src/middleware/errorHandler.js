// src/middleware/errorHandler.js
const { AppError } = require('../utils/errors');

const errorHandler = (err, req, res, next) => {
  if (process.env.NODE_ENV === 'development') console.error('Error:', err);

  // Zod validation
  if (err.name === 'ZodError') {
    return res.status(400).json({
      success: false,
      error: {
        code: 'VALIDATION_ERROR', message: 'Validation failed',
        details: err.errors.map(e => ({ field: e.path.join('.'), message: e.message })),
      },
    });
  }

  // Prisma unique constraint
  if (err.code === 'P2002') {
    return res.status(409).json({
      success: false,
      error: { code: 'CONFLICT', message: 'A record with this value already exists', details: { fields: err.meta?.target } },
    });
  }

  // Prisma not found
  if (err.code === 'P2025') {
    return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Record not found' } });
  }

  // Postgres unique constraint
  if (err.code === '23505') {
    return res.status(409).json({ success: false, error: { code: 'CONFLICT', message: 'Duplicate entry — value already exists' } });
  }

  // Postgres foreign key
  if (err.code === '23503') {
    return res.status(400).json({ success: false, error: { code: 'VALIDATION_ERROR', message: 'Referenced record does not exist' } });
  }

  // Custom AppError
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      success: false,
      error: { code: err.code, message: err.message, ...(err.details && { details: err.details }) },
    });
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError')
    return res.status(401).json({ success: false, error: { code: 'INVALID_TOKEN', message: 'Invalid token' } });
  if (err.name === 'TokenExpiredError')
    return res.status(401).json({ success: false, error: { code: 'TOKEN_EXPIRED', message: 'Token has expired' } });

  // Default
  return res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: process.env.NODE_ENV === 'production' ? 'An unexpected error occurred' : err.message,
    },
  });
};

module.exports = errorHandler;
