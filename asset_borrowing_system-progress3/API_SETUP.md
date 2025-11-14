# API Setup Guide

## Setting up the API connection

The registration screen is now connected to your backend API. You need to configure the correct API URL based on your testing environment.

### Configuration Location

Open `lib/services/api_service.dart` and update the `baseUrl` constant:

### Different Environments

#### 1. **Android Emulator**
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```
The Android emulator uses `10.0.2.2` to refer to your host machine's `localhost`.

#### 2. **iOS Simulator**
```dart
static const String baseUrl = 'http://localhost:3000/api';
```
Or use your machine's IP address:
```dart
static const String baseUrl = 'http://192.168.x.x:3000/api';
```

#### 3. **Physical Device (Android/iOS)**
Find your computer's IP address and use it:
```dart
static const String baseUrl = 'http://YOUR_IP_ADDRESS:3000/api';
```

**To find your IP address:**
- **macOS/Linux**: Run `ifconfig | grep "inet "` in terminal
- **Windows**: Run `ipconfig` in command prompt

Make sure your phone and computer are on the same WiFi network.

### Backend Server Setup

Make sure your backend server is running on the correct host:

```javascript
const HOST = '0.0.0.0'; // Listen on all network interfaces
const PORT = 3000;
```

This allows connections from your local network, not just localhost.

### Testing the Connection

1. **Start your backend server:**
   ```bash
   node server.js
   ```

2. **Update the API URL** in `lib/services/api_service.dart`

3. **Run the Flutter app:**
   ```bash
   flutter run
   ```

4. **Try registering** a new user through the app

### API Endpoints Used

- **POST** `/api/register` - Register a new student user
  - Required fields: `email`, `password`, `first_name`, `username`
  - Optional fields: `last_name`, `ph_num`

### Troubleshooting

**Connection refused error:**
- Check if the backend server is running
- Verify the IP address and port are correct
- Make sure firewall isn't blocking the connection
- For physical devices, ensure phone and computer are on same WiFi

**"Username or email already exists" error:**
- This means a user with that username/email is already registered
- Try using a different username or email

**Network error:**
- Check your internet/network connection
- Verify the backend server URL is accessible
- Try pinging the server URL from a browser

### Success Flow

When registration is successful:
1. User sees a green success message
2. User is redirected to the login screen
3. They can now login with their credentials

### Error Handling

The app handles these scenarios:
- Network errors (server not reachable)
- Duplicate username/email
- Validation errors (missing fields, weak password, etc.)
- Server errors

All errors are displayed as red snackbars at the bottom of the screen.
