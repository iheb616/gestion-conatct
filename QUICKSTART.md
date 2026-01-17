# Quick Start Guide - Contact Management App

## 🚀 Quick Start for Web (Chrome)

### 1. Start the Backend
```bash
# Windows
start_backend.bat

# Mac/Linux
bash start_backend.sh
```
The backend will run at: http://localhost:8000

### 2. Run the Flutter App
```bash
flutter run -d chrome
```

---

## 📱 Quick Start for Android

### 1. Start the Backend
Same as above - run `start_backend.bat` or `start_backend.sh`

### 2. Configure API URL

**Option A: Using Android Emulator**
- The app is already configured for emulator (10.0.2.2:8000)
- Just run: `flutter run`

**Option B: Using Physical Device**
1. Find your computer's local IP address:
   - Windows: `ipconfig` (look for IPv4 Address)
   - Mac/Linux: `ifconfig` or `ip addr show`
   
2. Update the API URL in `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_IP:8000';  // e.g., 'http://192.168.1.100:8000'
   ```

3. Make sure your phone and computer are on the same WiFi network

4. Run: `flutter run -d <device-id>`

---

## 🔧 First Time Setup

### Prerequisites
- Flutter SDK 3.0+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Python 3.8+ ([Install Python](https://www.python.org/downloads/))
- Chrome browser (for web)
- Android Studio (for Android)

### Installation Steps

1. **Clone the repository**
   ```bash
   cd gestion-conatct
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Python backend**
   ```bash
   cd backend
   python -m venv venv
   
   # Activate virtual environment
   # Windows: venv\Scripts\activate
   # Mac/Linux: source venv/bin/activate
   
   pip install -r requirements.txt
   ```

---

## 📖 API Documentation

Once the backend is running, visit:
- **API Docs**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc

---

## ✅ Testing the Setup

1. Start the backend server
2. Open browser to http://localhost:8000 - you should see: `{"status":"ok","message":"Contact Management API is running"}`
3. Run the Flutter app
4. Register a new account
5. Add a contact
6. Test search, delete functionality

---

## 🐛 Troubleshooting

### Backend Issues

**"Module not found" error**
```bash
cd backend
pip install -r requirements.txt
```

**"Port already in use" error**
```bash
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:8000 | xargs kill -9
```

### Flutter Issues

**"No device found"**
```bash
flutter devices
# Make sure you have a device/emulator running
```

**"Package not found"**
```bash
flutter pub get
flutter clean
flutter pub get
```

### Android Connection Issues

**Can't connect to backend from Android device**
1. Verify computer and phone are on same WiFi
2. Check your firewall settings allow port 8000
3. Update API URL with correct IP address
4. Try pinging your computer from phone

---

## 🎨 Features

✅ User Registration & Login  
✅ Create Contacts  
✅ View All Contacts  
✅ Search Contacts  
✅ Delete Contacts  
✅ Responsive UI  
✅ Real-time API Integration  
✅ Form Validation  
✅ Error Handling  

---

## 📁 Project Structure

```
gestion-conatct/
├── lib/                    # Flutter source code
│   ├── main.dart          # Entry point
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── services/          # API integration
│   ├── theme/             # App theme
│   ├── utils/             # Utilities
│   └── widgets/           # Reusable widgets
├── backend/               # Python backend
│   ├── main.py           # FastAPI app
│   ├── models.py         # Data models & schemas
│   ├── database.py       # DB configuration
│   └── requirements.txt  # Python packages
├── android/              # Android platform
├── web/                  # Web platform
└── pubspec.yaml          # Flutter dependencies
```

---

## 🔑 Default Test Credentials

You'll need to register your own account - there are no default credentials.

---

## 📝 Notes

- The app uses SQLite for database (automatically created)
- Database file: `backend/contacts.db`
- All passwords are hashed with SHA-256
- API supports pagination (default: 100 items)
- CORS is enabled for all origins (configure for production)

---

## 🆘 Need Help?

1. Check the detailed README_DETAILED.md
2. Review the API documentation at /docs endpoint
3. Check Flutter logs: `flutter logs`
4. Check backend logs in the terminal where server is running

---

## 🚀 Building for Production

**Web:**
```bash
flutter build web
```
Output: `build/web/`

**Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`
