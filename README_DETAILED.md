# Contact Management App

A modern contact management application built with Flutter for the frontend and FastAPI for the backend.

## Features

- 🔐 User authentication (register/login)
- 📇 Create, read, and delete contacts
- 🌐 Web support (Chrome)
- 📱 Android support
- 🎨 Modern, responsive UI
- ⚡ Fast backend API with SQLite

## Tech Stack

### Frontend
- Flutter 3.x
- Material Design
- HTTP client for API communication

### Backend
- Python 3.x
- FastAPI
- SQLAlchemy
- SQLite database
- Pydantic for validation

## Project Structure

```
gestion-conatct/
├── lib/                    # Flutter app source code
│   ├── main.dart          # App entry point
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── services/          # API services
│   ├── theme/             # App theming
│   └── utils/             # Utilities
├── backend/               # Python backend
│   ├── main.py           # FastAPI app
│   ├── models.py         # Database models
│   ├── database.py       # Database configuration
│   └── requirements.txt  # Python dependencies
├── android/              # Android platform files
├── web/                  # Web platform files
└── pubspec.yaml          # Flutter dependencies

```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Python 3.8 or higher
- Chrome browser (for web)
- Android Studio (for Android development)

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Create a virtual environment:
```bash
python -m venv venv
```

3. Activate the virtual environment:
   - Windows: `venv\Scripts\activate`
   - macOS/Linux: `source venv/bin/activate`

4. Install dependencies:
```bash
pip install -r requirements.txt
```

5. Run the backend server:
```bash
python main.py
```

The API will be available at `http://localhost:8000`

### Flutter Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. **For Web:**
```bash
flutter run -d chrome
```

3. **For Android:**
   - Connect your Android device or start an emulator
   - Update the API base URL in `lib/services/api_service.dart`:
     - For emulator: `http://10.0.2.2:8000`
     - For physical device: `http://YOUR_COMPUTER_IP:8000`
   ```bash
   flutter run -d <device-id>
   ```

## API Endpoints

### Authentication
- `POST /register` - Register new user
- `POST /login` - Login user

### Contacts
- `GET /personnes` - Get all contacts
- `POST /personnes` - Create new contact
- `GET /personnes/{id}` - Get specific contact
- `DELETE /personnes/{id}` - Delete contact

## Configuration

### API Base URL
Update the `baseUrl` in `lib/services/api_service.dart`:
- Web: `http://localhost:8000`
- Android Emulator: `http://10.0.2.2:8000`
- Android Physical Device: `http://YOUR_LOCAL_IP:8000`

## Building for Production

### Web
```bash
flutter build web
```

### Android
```bash
flutter build apk --release
```

## Optimizations Implemented

### Frontend
- ✅ Removed unused platform folders (iOS, macOS, Linux, Windows)
- ✅ Removed unnecessary dependencies (sqflite, path_provider)
- ✅ Cleaned up unused files and models
- ✅ Added proper error handling with timeouts
- ✅ Improved API service with retry logic
- ✅ Optimized imports and code structure

### Backend
- ✅ Added comprehensive input validation
- ✅ Improved error handling with proper HTTP status codes
- ✅ Added email validation
- ✅ Added phone number validation
- ✅ Optimized database queries with pagination
- ✅ Added API documentation
- ✅ Improved code structure and comments

## License

MIT License

## Authors

- Khemiri Iheb
- Khiari Bilel
