# 🚀 WildX — Play Store Build Guide

## Step 1 — Keystore හදන්න (ෙඑකක් විතරක් හදන්න, save කරන්න!)

```bash
keytool -genkey -v -keystore wildx-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias wildx
```
Password, name etc. fill කරන්න. **wildx-release.jks file safe place එකක store කරන්න!**

---

## Step 2 — key.properties file හදන්න

`wildx-frontend/android/key.properties` file හදලා මේක paste කරන්න:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=wildx
storeFile=../wildx-release.jks
```

> wildx-release.jks file → `wildx-frontend/android/` folder එකට copy කරන්න

---

## Step 3 — build.gradle.kts update කරන්න

`wildx-frontend/android/app/build.gradle.kts` open කරලා මේ add කරන්න:

```kotlin
// Top of file, after plugins block:
val keystoreProperties = java.util.Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

// Inside android { } block, before defaultConfig:
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

// Inside buildTypes { release { } }:
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        isShrinkResources = true
    }
}
```

---

## Step 4 — AAB Build කරන්න

```bash
cd wildx-frontend
flutter pub get
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Step 5 — Play Console Upload

1. [play.google.com/console](https://play.google.com/console) → Create app
2. App name: **WildX - Sri Lanka Wildlife**
3. Category: **Travel & Local**
4. Production → Create new release → Upload `app-release.aab`
5. Fill in store listing (description, screenshots, icon)

---

## App Details

| Field | Value |
|-------|-------|
| Package name | `com.wildx.wildlife` |
| App name | WildX - Sri Lanka Wildlife |
| Version | 1.0.1 (2) |
| Min Android | 5.0+ |

---

## APK (testing සඳහා)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

Direct install: `adb install build/app/outputs/flutter-apk/app-release.apk`
