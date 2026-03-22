# 🦁 WildX — Full Stack Setup Guide

Sri Lanka Wildlife Safari App — Flutter (Firebase) + Node.js (Neon PostgreSQL)

---

## 📁 Project Structure

```
wildx-project/
├── wildx/                  ← Flutter Frontend
│   └── lib/
│       ├── core/
│       │   ├── config/
│       │   │   └── app_config.dart   ← 🔧 CHANGE BACKEND URL HERE
│       │   └── services/
│       │       └── backend_service.dart
│       ├── features/       ← Auth, Parks, SOS, Gallery, Accommodation…
│       ├── firebase_options.dart     ← Firebase already configured
│       └── main.dart
└── wildx-backend/          ← Node.js + Express + Neon PostgreSQL
    ├── .env                ← 🔧 FILL IN YOUR NEON DB URL HERE
    ├── server.js
    ├── src/
    │   ├── routes/
    │   ├── controllers/
    │   ├── config/
    │   └── db/
    └── prisma/
```

---

## ⚡ Quick Start

### Step 1 — Backend Setup

```bash
cd wildx-backend

# Install dependencies
npm install

# Configure environment
# Open .env and set DATABASE_URL to your Neon connection string
# (See "Neon Database Setup" below)

# Run database migrations (creates all tables)
npm run db:migrate

# Run Prisma migrations (for accommodations/bookings)
npx prisma db push

# Seed initial data (animals, notifications)
npm run db:seed

# Start the server
npm run dev          # development (with hot-reload)
npm start            # production
```

Server runs at: `http://localhost:3000`
Health check: `http://localhost:3000/health`

---

### Step 2 — Frontend Setup

```bash
cd wildx

# Install Flutter dependencies
flutter pub get

# Run on Android device/emulator
flutter run
```

---

## 🔧 Configuration

### Backend URL (IMPORTANT)

Open `wildx/lib/core/config/app_config.dart` and set `backendUrl`:

| Platform | URL |
|----------|-----|
| Flutter Web / Chrome | `http://localhost:3000` |
| Android Emulator | `http://10.0.2.2:3000` |
| Android Physical Device (same Wi-Fi) | `http://YOUR_PC_IP:3000` |
| Production | `https://your-api.onrender.com` |

```dart
static const String backendUrl = 'http://10.0.2.2:3000'; // ← change this
```

---

## 🗄️ Neon Database Setup

1. Go to [https://console.neon.tech](https://console.neon.tech) → Create a new project
2. Copy the **Connection String** (looks like `postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/neondb?sslmode=require`)
3. Open `wildx-backend/.env` and paste it as `DATABASE_URL`
4. Run `npm run db:migrate` to create all tables

---

## 🔥 Firebase Setup

Firebase is **already connected** to project `wildx-6d2ef`.

The app uses:
- **Firebase Authentication** — Email, Phone, Google Sign-In
- **Cloud Firestore** — Real-time data
- **Firebase Storage** — Photo uploads

### To use Firebase Admin in the backend (for token verification):
1. Go to [Firebase Console](https://console.firebase.google.com) → `wildx-6d2ef`
2. Project Settings → Service Accounts → **Generate new private key**
3. Save the downloaded JSON as `wildx-backend/firebase-service-account.json`

> ⚠️ **Never commit** `firebase-service-account.json` or `.env` to Git!

---

## 🛣️ Backend API Endpoints

| Module | Base Path |
|--------|-----------|
| Auth | `POST /api/auth/register` `POST /api/auth/login` `POST /api/auth/firebase/login` |
| Users | `GET /api/users/:id` `PUT /api/users/:id` |
| Parks | `GET /api/parks` `GET /api/national-parks` |
| Sightings | `GET /api/sightings` `POST /api/sightings` |
| Accommodations | `GET /api/v1/accommodations` `POST /api/v1/bookings` |
| Gallery | `GET /api/v1/animals` `GET /api/v1/photos` |
| SOS | `POST /api/sos` `GET /api/emergency` |
| Notifications | `GET /api/v1/notifications` |
| Markers | `GET /api/markers` |

Full health check: `GET /health`

---

## 📦 Tech Stack

### Frontend
- Flutter 3.x (Dart)
- Firebase Auth, Firestore, Storage
- `http` package for REST calls
- `geolocator` for GPS
- `image_picker` for photo uploads

### Backend
- Node.js 18+ / Express 4
- Neon PostgreSQL (via `pg` pool + Prisma ORM)
- Firebase Admin SDK (token verification)
- JWT for email/password auth
- Helmet + CORS security

---

## 🚀 Deployment

### Backend — Render (Free)
1. Push `wildx-backend/` to a GitHub repo
2. Create a new **Web Service** on [render.com](https://render.com)
3. Build command: `npm install && npm run db:migrate && npx prisma db push`
4. Start command: `npm start`
5. Add environment variables from `.env`

### Update Frontend for production:
```dart
// app_config.dart
static const String backendUrl = 'https://wildx-api.onrender.com';
```

---

## 🐛 Common Issues

| Problem | Fix |
|---------|-----|
| `Connection refused localhost:3000` on Android | Change `backendUrl` to `http://10.0.2.2:3000` |
| `DATABASE_URL is missing` | Fill in `.env` with your Neon connection string |
| Firebase sign-in fails | Ensure SHA-1/SHA-256 added in Firebase Console for Android |
| `SocketException` on iOS simulator | Use `http://localhost:3000` |
