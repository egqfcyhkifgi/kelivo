# Build X - AI Assistant Setup Guide

## 🚀 Overview
Build X is a streamlined AI assistant application that connects to a single AI model via API. This guide will help you set up and configure the application.

## 📋 What's Changed
- ✅ App name changed from "Kelivo" to "Build X"
- ✅ Version updated to 1.0.0
- ✅ Single API model integration (no model selection)
- ✅ Firebase authentication with Google Sign In
- ✅ Memory system added
- ✅ Simplified About page
- ✅ Removed unnecessary UI components (Docs, Sponsor, Assistant pages, etc.)
- ✅ Optimized codebase

## 🔧 Setup Instructions

### 1. Firebase Configuration
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication and add Google as a sign-in provider
3. Add your app to the Firebase project (Web, Android, iOS)
4. Download the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
   - Web config (update `lib/firebase_options.dart`)

### 2. API Configuration
Edit the `.env` file in the root directory:

```env
# Build X Configuration
# API URL for the AI model
API_URL=https://your-api-url-here.com

# Model Name
MODEL_NAME=Build X

# API Configuration
API_TIMEOUT=30000
MAX_TOKENS=4096
```

**To change the API URL:**
1. Open `.env` file
2. Update `API_URL=` with your new API endpoint
3. Restart the application

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Build and Run
```bash
# For development
flutter run

# For production builds
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## 🎨 Login Page Design
The login page features a clean, modern design:
- White background (#FFFFFF)
- "Build X" logo in the center
- Bottom sheet with authentication options:
  - Continue with Google (white background)
  - Sign up (light gray background)
  - Log in (black background)

## 🧠 Memory System
- Access memory settings from the main menu
- Toggle memory on/off
- Add custom memory context for conversations
- Memory is automatically included in API calls when enabled

## 🔐 Authentication Flow
1. User opens the app
2. If not authenticated, login page is shown
3. User can sign in with Google
4. Once authenticated, main chat interface is displayed
5. Authentication state is managed automatically

## 📱 Supported Platforms
- ✅ Web
- ✅ Android
- ✅ iOS
- ❌ Desktop (removed as requested)

## 🛠️ Technical Details

### API Integration
- Single API endpoint configuration
- Memory context integration
- Streaming responses supported
- Error handling and timeout management

### Authentication
- Firebase Auth with Google Sign In
- Persistent authentication state
- Secure token management

### Memory System
- Local storage of memory context
- Toggle-able memory functionality
- Automatic integration with API calls

## 🔍 Verification
Run the verification script to check all components:
```bash
./final_verification.sh
```

## 📞 Support
For technical support or questions about the Build X setup, please refer to the code documentation or contact the development team.

---
**Build X v1.0.0** - AI Assistant Application