# ✅ Registration Setup Checklist

## Before Testing

### 1. Backend Server
- [ ] Server is running (`node server.js`)
- [ ] You see: "🚀 Server is running on http://192.168.1.173:3000"
- [ ] Database is connected
- [ ] No errors in server console

### 2. Flutter App
- [ ] API URL updated to `http://192.168.1.173:3000/api`
- [ ] Run `flutter clean && flutter pub get` (already done ✅)
- [ ] No compilation errors

### 3. Network
- [ ] Phone/Simulator and computer on same WiFi (if using physical device)
- [ ] Firewall not blocking port 3000
- [ ] Server accessible via curl (already tested ✅)

## Testing Steps

1. **Start Backend Server**
   ```bash
   cd /path/to/your/backend
   node server.js
   ```

2. **Run Flutter App**
   ```bash
   cd /Users/bhonepyaemin/Documents/mob_final_asset_borrowing_system
   flutter run
   ```

3. **Test Registration**
   - Open the app
   - Navigate to registration screen
   - Fill in all fields:
     - First Name: Test
     - Last Name: User
     - Username: testuser123
     - Email: test@example.com
     - Password: password123
     - Confirm Password: password123
     - Phone: 0812345678
   - Click REGISTER button
   - Wait for loading spinner
   - **Expected:** Green success message → Redirect to login

4. **Verify in Database**
   ```sql
   SELECT * FROM users WHERE username = 'testuser123';
   ```

## What Changed

✅ **Updated:** `lib/services/api_service.dart`
- Changed from `http://localhost:3000/api`
- To: `http://192.168.1.173:3000/api`

✅ **Tested:** Server accessibility with curl - Working!

✅ **Cleaned:** Flutter build to pick up changes

## Common Issues & Solutions

### "Connection Refused" Error
**Cause:** Server not running or wrong IP
**Solution:** 
1. Check server is running
2. Verify IP matches your .env (192.168.1.173)
3. Try: `curl http://192.168.1.173:3000/api/register`

### "Network Error: ClientException"
**Cause:** Can't reach server
**Solution:**
1. Check firewall settings
2. Make sure both devices on same WiFi
3. Restart server and app

### "Username or email already exists"
**Cause:** User already registered (this is actually good - means API works!)
**Solution:** Use a different username/email

### Error 400: "email, password, first_name, username are required"
**Cause:** Missing required fields
**Solution:** Make sure all form fields are filled

## Success Indicators

✅ Server responds to curl test
✅ Form validation works
✅ Loading spinner appears when submitting
✅ Green success message shows
✅ Redirects to login screen
✅ User appears in database
✅ Can login with new credentials

## Next Steps After Successful Registration

1. **Test Login:** Try logging in with the new account
2. **Test Duplicate:** Try registering same username again (should fail)
3. **Test Validation:** Try invalid email, short password, etc.
4. **Check Database:** Verify password is hashed, not plain text

## Device-Specific Notes

### iOS Simulator (Current Setup ✅)
- Using: `http://192.168.1.173:3000/api`
- Should work immediately

### Android Emulator
- Need to change to: `http://10.0.2.2:3000/api`
- Edit `lib/services/api_service.dart` line 8

### Physical Device
- Using: `http://192.168.1.173:3000/api` ✅
- Must be on same WiFi as computer
- Check phone isn't using VPN

## Logs to Monitor

**Server Terminal:**
```
POST /api/register
Body: { email, password, first_name, ... }
Response: { message: 'Registration successful', uid: 1 }
```

**Flutter Console:**
- No red errors
- HTTP request logs (if debug enabled)
- Success/error messages

## Emergency Debugging

If nothing works, try this minimal test:

```bash
# Terminal 1: Start server
node server.js

# Terminal 2: Test with curl
curl -X POST http://192.168.1.173:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"pass123","first_name":"Test","username":"test123"}'

# Should return: {"message":"Registration successful","uid":...}
```

If curl works but app doesn't:
- Problem is in Flutter app
- Check API URL in api_service.dart
- Run `flutter clean && flutter pub get`
- Check for typos in the URL

If curl doesn't work:
- Problem is with server/network
- Check server is running
- Check firewall
- Check IP address is correct
