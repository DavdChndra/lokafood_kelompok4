# Setup Firebase — LokaFood UAS

## Yang perlu kamu lakukan (hanya ini!)

### 1. Buat Project Firebase
- Buka https://console.firebase.google.com
- Klik "Add project" → nama: `LokaFood-003` → Next → Disable Analytics → Create Project

### 2. Tambah App Android
- Di Firebase Console → Project Settings (⚙️) → Add App → Android
- Package name: cek di `android/app/build.gradle` → cari `applicationId`
  (biasanya `com.example.lokafood`)
- Nickname: LokaFood → Register App
- Download `google-services.json`
- Taruh file itu di folder `android/app/`

### 3. Aktifkan Authentication
- Sidebar → Authentication → Get Started
- Sign-in method → Email/Password → Enable → Save

### 4. Aktifkan Firestore
- Sidebar → Firestore Database → Create Database
- Pilih "Start in test mode" → Next → pilih region terdekat → Enable

### 5. Jalankan FlutterFire CLI
Buka terminal di folder project, jalankan:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
- Pilih project Firebase "lokafood" yang tadi dibuat
- Centang platform Android (dan iOS kalau perlu)
- Ini akan generate file `lib/firebase_options.dart` secara otomatis

### 6. flutter pub get
```bash
flutter pub get
```

### 7. Jalankan App
```bash
flutter run
```

---

## Alur Demo untuk Presentasi

1. Buka app → Splash → masuk ke Login (karena belum login)
2. Register akun baru → masuk ke HomeScreen
3. Tekan tombol **"⬆️ Seed"** di HomeScreen → data kuliner ter-upload ke Firestore
4. Refresh → data muncul dari Firebase
5. Explore → filter & search bekerja via ViewModel
6. Profile → nama & email tampil dari Firebase Auth
7. Logout → kembali ke LoginScreen
8. Login lagi → langsung masuk HomeScreen (data tetap ada di Firebase)

---

## Firestore Rules (optional, untuk keamanan)
Di Firebase Console → Firestore → Rules → paste ini:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
