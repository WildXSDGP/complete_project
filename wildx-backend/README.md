# WildX Unified Backend v2.0

Complete merged backend for the **WildX Sri Lanka Wildlife Safari App** — all 8 Node.js sub-projects combined into a single Express server.

---

## 🚀 Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Set up environment
cp .env.example .env
# → Edit .env and add your DATABASE_URL, JWT_SECRET

# 3. Create all pg tables
npm run db:migrate

# 4. Seed initial data (parks, safety tips, emergency contacts, animals)
npm run db:seed

# 5. (Optional) Seed Prisma tables (accommodations, parks_prisma)
npm run prisma:generate
npm run prisma:push
npm run prisma:seed

# 6. Start development server
npm run dev
```

---

## 📋 Environment Variables

| Variable | Description |
|---|---|
| `DATABASE_URL` | Neon PostgreSQL connection string |
| `JWT_SECRET` | Secret key for JWT signing |
| `JWT_EXPIRES_IN` | Access token expiry (default: `1h`) |
| `JWT_REFRESH_EXPIRES_IN` | Refresh token expiry (default: `7d`) |
| `PORT` | Server port (default: `3000`) |
| `NODE_ENV` | `development` or `production` |
| `FIREBASE_SERVICE_ACCOUNT` | Path to Firebase service account JSON |

---

## 📡 API Reference

### Auth — `/api/auth`
| Method | Endpoint | Description |
|---|---|---|
| POST | `/register` | Register with email + password |
| POST | `/login` | Login with email + password |
| POST | `/refresh` | Refresh access token |
| POST | `/logout` | Logout |
| POST | `/firebase/register` | Register via Firebase token |
| POST | `/firebase/login` | Login via Firebase token |
| GET | `/health` | Health check |

### Users — `/api/users`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | All users |
| GET | `/:id` | User + badges + top_parks |
| POST | `/` | Create user |
| PUT | `/:id` | Update profile |
| PATCH | `/:id/xp` | Update XP and level |
| PATCH | `/:id/stat` | Increment sightings/parks/photos count |
| DELETE | `/:id` | Delete user |

### Parks — `/api/parks`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | All parks |
| GET | `/featured` | Featured park |
| GET | `/:id` | Park by ID |
| POST | `/` | Create park |
| PUT | `/:id` | Update park |
| DELETE | `/:id` | Delete park |

### Sightings — `/api/sightings`
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/recent` | No | 10 most recent sightings |
| GET | `/my` | ✅ | My sightings |
| GET | `/:id` | No | Sighting by ID |
| POST | `/` | ✅ | Create sighting |
| PUT | `/:id` | ✅ | Update sighting |
| DELETE | `/:id` | ✅ | Delete sighting |

### Wildlife Sightings (Advanced) — `/api/wildlife-sightings`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | All (`?animal_type=&limit=&offset=`) |
| GET | `/stats` | Stats by animal type and status |
| GET | `/:id` | Single sighting |
| POST | `/` | Create (geo + validation) |
| PUT | `/:id/status` | Update status (submitted/verified/rejected) |
| DELETE | `/:id` | Delete |

### Accommodations — `/api/v1/accommodations`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | List (`?maxPrice=&parkName=&sortBy=rating`) |
| GET | `/:id` | Single accommodation |
| GET | `/:id/availability` | Check availability (`?checkIn=&checkOut=`) |

### Bookings — `/api/v1/bookings`
| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/` | Optional | Create booking |
| GET | `/` | ✅ | My bookings |
| GET | `/:bookingId` | ✅ | Single booking |
| DELETE | `/:bookingId` | ✅ | Cancel booking |

### Badges — `/api/badges`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/user/:user_id` | All badges for user |
| POST | `/` | Create badge |
| PATCH | `/:id/earn` | Mark as earned |
| DELETE | `/:id` | Delete badge |

### Park Visits — `/api/park-visits`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/user/:user_id` | All visits for user |
| POST | `/` | Add park visit |
| PATCH | `/:id/visit` | Increment visit count |
| PUT | `/:id` | Update park visit |
| DELETE | `/:id` | Delete park visit |

### SOS — `/api/sos`
| Method | Endpoint | Description |
|---|---|---|
| POST | `/alert` | Send SOS alert |
| GET | `/alerts` | All alerts (`?status=pending`) |
| PATCH | `/alerts/:id/status` | Update alert status |

### Emergency — `/api/emergency`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/contacts` | Emergency contacts |
| POST | `/contacts` | Add contact |
| PUT | `/contacts/:id` | Update contact |
| DELETE | `/contacts/:id` | Soft-delete contact |
| GET | `/safety-tips` | Safety tips (`?category=wildlife`) |
| POST | `/safety-tips` | Add tip |
| DELETE | `/safety-tips/:id` | Deactivate tip |
| POST | `/location/update` | Share user location |
| GET | `/location/history/:userId` | Location history |

### Gallery — `/api/v1`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/animals` | All animals (`?search=&category=&park=`) |
| GET | `/animals/categories` | Unique categories |
| GET | `/animals/parks` | Unique parks |
| GET | `/animals/favorites` | Favourited animals |
| GET | `/animals/:id` | Single animal |
| PATCH | `/animals/:id/favorite` | Toggle favourite |
| GET | `/photos` | Community photos (`?animalType=&parkName=`) |
| GET | `/photos/user/:uploadedBy` | Photos by user |
| POST | `/photos` | Upload photo |
| DELETE | `/photos/:id` | Delete photo |

### Notifications — `/api/v1/notifications`
| Method | Endpoint | Description |
|---|---|---|
| GET | `/` | All (`?type=&userId=&unread=true`) |
| GET | `/unread-count` | Unread count for bell badge |
| GET | `/:id` | Single notification |
| POST | `/` | Create notification |
| PATCH | `/:id/read` | Mark as read |
| PATCH | `/read-all` | Mark all as read |
| DELETE | `/:id` | Soft-delete one |
| DELETE | `/delete-all` | Soft-delete all |

---

## 🗄️ Database Architecture

Two ORM layers are used:

| Layer | Tables | Used for |
|---|---|---|
| **pg (raw SQL)** | users, firebase_users, parks, sightings, wildlife_sightings, badges, park_visits, animals, sos_alerts, emergency_contacts, user_locations, safety_tips | Most features |
| **Prisma** | auth_users, accommodations_prisma, parks_prisma, bookings, refresh_tokens, accommodation_images | Accommodation booking module |
| **Sequelize** | wildlife_animal, wildlife_photos, notifications | Gallery + Notifications |

---

## 🔥 Firebase Auth Setup (Optional)

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click **Generate new private key** → download `firebase-service-account.json`
3. Place it in the project root
4. Set `FIREBASE_SERVICE_ACCOUNT=./firebase-service-account.json` in `.env`

If not configured, Firebase routes return `503` and all other routes work normally.

---

## 🧱 Architecture

```
wildx-backend/
├── server.js                  ← Entry point
├── prisma/
│   ├── schema.prisma          ← Accommodation/booking schema
│   └── seed.js
├── src/
│   ├── config/
│   │   ├── db.js              ← pg Pool
│   │   ├── database.js        ← Sequelize
│   │   └── neon.js            ← Neon serverless (SOS)
│   ├── controllers/           ← All business logic
│   ├── routes/                ← All route definitions
│   ├── middleware/            ← auth, validate, errorHandler
│   ├── models/                ← Sequelize models
│   ├── seeders/               ← Data seeders
│   ├── utils/                 ← errors, response, prisma client
│   └── db/
│       ├── migrate.js         ← Creates all pg tables
│       └── seed.js            ← Seeds initial data
└── .env.example
```
