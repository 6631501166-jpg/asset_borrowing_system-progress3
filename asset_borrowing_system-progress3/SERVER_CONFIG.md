# Server Connection Configuration

## ✅ Current Setup (Updated)

Your server is configured with:
- **IP Address:** 192.168.1.173
- **Port:** 3000
- **API Base URL:** http://192.168.1.173:3000/api

The Flutter app has been updated to use this URL.

## 📱 Device-Specific Configuration

### If testing on iOS Simulator:
✅ Current setting should work: `http://192.168.1.173:3000/api`

### If testing on Android Emulator:
You need to use: `http://10.0.2.2:3000/api`

**To switch to Android Emulator:**
Edit `lib/services/api_service.dart` and change line 9 to:
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

### If testing on Physical Device:
✅ Current setting should work: `http://192.168.1.173:3000/api`

**Important:** Make sure your phone and computer are on the **same WiFi network**.

## 🔧 Troubleshooting

### Issue: "Connection Refused"

**Solution 1: Check Server is Running**
```bash
# In your backend directory, start the server:
node server.js

# You should see:
# 🚀 Server is running on http://192.168.1.173:3000
```

**Solution 2: Verify Server Listens on All Interfaces**
Make sure your Node.js server uses `HOST=0.0.0.0` or your specific IP:

```javascript
const HOST = process.env.HOST || '0.0.0.0';
const PORT = process.env.PORT || 3000;

app.listen(PORT, HOST, () => {
  console.log(`Server running on http://${HOST}:${PORT}`);
});
```

**Solution 3: Check Firewall**
On macOS, the firewall might block incoming connections:
1. Go to System Preferences → Security & Privacy → Firewall
2. Click "Firewall Options"
3. Make sure Node.js is allowed to receive incoming connections

**Solution 4: Test Server Accessibility**
```bash
# From your Mac terminal:
curl http://192.168.1.173:3000/api/register

# Should return: "email, password, first_name, username are required"
```

### Issue: "Network Error" on Physical Device

**Checklist:**
- [ ] Phone and computer on same WiFi?
- [ ] Server is running?
- [ ] Using correct IP address (192.168.1.173)?
- [ ] Firewall allowing connections?
- [ ] Phone not using VPN or proxy?

### Issue: Different IP Address After Restart

If your IP address changes (Dynamic IP):
1. Find new IP: `ifconfig | grep "inet " | grep -v 127.0.0.1`
2. Update `.env` file with new IP
3. Update `lib/services/api_service.dart` with new IP
4. Restart server and Flutter app

## 🧪 Testing the Connection

### Step 1: Test from Terminal
```bash
curl -X POST http://192.168.1.173:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "first_name": "Test",
    "last_name": "User",
    "username": "testuser"
  }'
```

Expected response:
```json
{"message":"Registration successful","uid":1}
```

### Step 2: Test from Flutter App
1. Run the app
2. Go to registration screen
3. Fill in the form
4. Click REGISTER
5. Watch for success message or error

## 📝 Current Configuration Status

✅ Server IP: 192.168.1.173
✅ Server Port: 3000
✅ Flutter API URL: Updated
✅ Server Accessibility: Confirmed (tested with curl)

## 🚀 Quick Start Commands

```bash
# Terminal 1: Start Backend Server
cd /path/to/your/backend
node server.js

# Terminal 2: Run Flutter App
cd /Users/bhonepyaemin/Documents/mob_final_asset_borrowing_system
flutter run
```

## 💡 Pro Tips

1. **Keep server running** while testing the app
2. **Watch server logs** to see incoming requests
3. **Check both** server terminal and app for error messages
4. **Use the same WiFi** for all devices
5. **Disable VPN** on phone if testing with physical device

## 📞 Quick Reference

| Environment | Base URL |
|------------|----------|
| iOS Simulator | `http://192.168.1.173:3000/api` ✅ Current |
| Android Emulator | `http://10.0.2.2:3000/api` |
| Physical Device | `http://192.168.1.173:3000/api` ✅ Current |
| Localhost Testing | `http://localhost:3000/api` |
