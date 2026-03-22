// accommodationController.js — pg direct (accommodations_prisma + accommodation_images + parks_prisma)
const { query } = require('../config/db');

const fmt = (a, images = []) => ({
  id: a.id, name: a.name, parkName: a.park_name,
  pricePerNight: parseFloat(a.price_per_night),
  distanceFromGate: parseFloat(a.distance_from_gate),
  travelTime: a.travel_time, fuelStops: a.fuel_stops,
  rating: parseFloat(a.rating),
  isEcoFriendly: a.is_eco_friendly,
  isFamilyFriendly: a.is_family_friendly,
  hasJeepHire: a.has_jeep_hire,
  description: a.description,
  imageUrls: images,
});

// GET /api/v1/accommodations
exports.getAll = async (req, res, next) => {
  try {
    const { maxPrice, maxDistance, ecoFriendly, familyFriendly, parkName, sortBy = 'rating' } = req.query;

    let sql = `
      SELECT a.*, p.name AS park_name
      FROM accommodations_prisma a
      JOIN parks_prisma p ON a.park_id = p.id
      WHERE 1=1`;
    const params = [];
    let i = 1;

    if (maxPrice)      { sql += ` AND a.price_per_night <= $${i++}`;    params.push(parseFloat(maxPrice)); }
    if (maxDistance)   { sql += ` AND a.distance_from_gate <= $${i++}`; params.push(parseFloat(maxDistance)); }
    if (ecoFriendly === 'true')  { sql += ` AND a.is_eco_friendly = true`; }
    if (familyFriendly === 'true') { sql += ` AND a.is_family_friendly = true`; }
    if (parkName)      { sql += ` AND p.name ILIKE $${i++}`;  params.push(`%${parkName}%`); }

    const order = sortBy === 'price' ? 'a.price_per_night ASC'
                : sortBy === 'distance' ? 'a.distance_from_gate ASC'
                : 'a.rating DESC';
    sql += ` ORDER BY ${order}`;

    const r = await query(sql, params);

    // Attach images
    const result = await Promise.all(r.rows.map(async (a) => {
      const imgs = await query(
        'SELECT image_url FROM accommodation_images WHERE accommodation_id=$1 ORDER BY sort_order',
        [a.id]
      );
      return fmt(a, imgs.rows.map(i => i.image_url));
    }));

    res.json({ success: true, data: { accommodations: result, total: result.length } });
  } catch (err) { next(err); }
};

// GET /api/v1/accommodations/:id
exports.getById = async (req, res, next) => {
  try {
    const r = await query(
      `SELECT a.*, p.name AS park_name FROM accommodations_prisma a
       JOIN parks_prisma p ON a.park_id = p.id WHERE a.id = $1`,
      [req.params.id]
    );
    if (!r.rows.length) return res.status(404).json({ success: false, error: 'Not found' });
    const imgs = await query(
      'SELECT image_url FROM accommodation_images WHERE accommodation_id=$1 ORDER BY sort_order',
      [req.params.id]
    );
    res.json({ success: true, data: { accommodation: fmt(r.rows[0], imgs.rows.map(i => i.image_url)) } });
  } catch (err) { next(err); }
};

// GET /api/v1/accommodations/:id/availability
exports.getAvailability = async (req, res) => {
  res.json({ success: true, available: true, message: 'Available for booking' });
};

// ── Booking ───────────────────────────────────────────────────

// POST /api/v1/bookings
exports.createBooking = async (req, res, next) => {
  try {
    const { accommodationId, checkInDate, checkOutDate, adults = 1, children = 0, userId, totalPrice = 0 } = req.body;
    if (!accommodationId || !checkInDate || !checkOutDate)
      return res.status(400).json({ success: false, error: 'accommodationId, checkInDate, checkOutDate required' });

    const bookingId = 'bk_' + Date.now() + '_' + Math.random().toString(36).slice(2,7);
    const nights = Math.ceil((new Date(checkOutDate) - new Date(checkInDate)) / 86400000);
    const accr = await query('SELECT price_per_night FROM accommodations_prisma WHERE id=$1', [accommodationId]);
    const pricePer = accr.rows.length ? parseFloat(accr.rows[0].price_per_night) : 0;
    const accommodationCost = pricePer * (adults + children * 0.5) * nights;
    const serviceFee = accommodationCost * 0.05;
    const total = totalPrice || (accommodationCost + serviceFee);

    // Create bookings table if not exists
    await query(`
      CREATE TABLE IF NOT EXISTS bookings (
        id TEXT PRIMARY KEY, accommodation_id TEXT, user_id TEXT,
        check_in_date DATE, check_out_date DATE,
        adults INT DEFAULT 1, children INT DEFAULT 0,
        accommodation_cost DECIMAL(10,2), service_fee DECIMAL(10,2), total_price DECIMAL(10,2),
        status TEXT DEFAULT 'confirmed', created_at TIMESTAMPTZ DEFAULT NOW(), updated_at TIMESTAMPTZ DEFAULT NOW()
      )
    `);
    const r = await query(
      `INSERT INTO bookings (id, accommodation_id, user_id, check_in_date, check_out_date, adults, children, accommodation_cost, service_fee, total_price, status)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,'confirmed') RETURNING *`,
      [bookingId, accommodationId, userId || null, checkInDate, checkOutDate, adults, children, accommodationCost, serviceFee, total]
    );
    res.status(201).json({ success: true, booking: r.rows[0] });
  } catch (err) { next(err); }
};

// GET /api/v1/bookings
exports.getBookings = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM bookings ORDER BY created_at DESC LIMIT 50').catch(() => ({ rows: [] }));
    res.json({ success: true, bookings: r.rows });
  } catch (err) { next(err); }
};

// GET /api/v1/bookings/:bookingId
exports.getBookingById = async (req, res, next) => {
  try {
    const r = await query('SELECT * FROM bookings WHERE id=$1', [req.params.bookingId]).catch(() => ({ rows: [] }));
    if (!r.rows.length) return res.status(404).json({ success: false, error: 'Booking not found' });
    res.json({ success: true, booking: r.rows[0] });
  } catch (err) { next(err); }
};

// DELETE /api/v1/bookings/:bookingId
exports.cancelBooking = async (req, res, next) => {
  try {
    await query("UPDATE bookings SET status='cancelled' WHERE id=$1", [req.params.bookingId]).catch(() => {});
    res.json({ success: true, message: 'Booking cancelled' });
  } catch (err) { next(err); }
};

// ── Alias ─────────────────────────────────────────────────────
exports.checkAvailability = exports.getAvailability;
