// src/middleware/validate.js
const validate = (schema) => (req, res, next) => {
  try { req.body = schema.parse(req.body); next(); } catch (e) { next(e); }
};

const validateQuery = (schema) => (req, res, next) => {
  try { req.query = schema.parse(req.query); next(); } catch (e) { next(e); }
};

const validateParams = (schema) => (req, res, next) => {
  try { req.params = schema.parse(req.params); next(); } catch (e) { next(e); }
};

module.exports = { validate, validateQuery, validateParams };
