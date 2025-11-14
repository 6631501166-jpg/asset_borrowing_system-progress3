// lib/services/session_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUid = 'uid';
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyRole = 'role';
  static const String _keyToken = 'token';

  // Save user session after login
  static Future<void> saveSession({
    required int userId,
    required String uid,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    String? token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyFirstName, firstName);
    await prefs.setString(_keyLastName, lastName);
    await prefs.setString(_keyRole, role);
    if (token != null) {
      await prefs.setString(_keyToken, token);
    }

    print('✅ Session saved for user: $firstName $lastName (ID: $userId)');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get user ID (for API calls like borrowing)
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // Get UID
  static Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid);
  }

  // Get username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Get email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Get first name
  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName);
  }

  // Get last name
  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastName);
  }

  // Get full name
  static Future<String> getFullName() async {
    final firstName = await getFirstName() ?? '';
    final lastName = await getLastName() ?? '';
    return '$firstName $lastName'.trim();
  }

  // Get role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Get all user data as a map
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'userId': prefs.getInt(_keyUserId),
      'uid': prefs.getString(_keyUid),
      'username': prefs.getString(_keyUsername),
      'email': prefs.getString(_keyEmail),
      'firstName': prefs.getString(_keyFirstName),
      'lastName': prefs.getString(_keyLastName),
      'role': prefs.getString(_keyRole),
      'token': prefs.getString(_keyToken),
    };
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUid);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyToken);

    print('✅ Session cleared');
  }

  // Update specific fields (if needed)
  static Future<void> updateFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, firstName);
  }

  static Future<void> updateLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastName, lastName);
  }

  static Future<void> updateEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }
}
