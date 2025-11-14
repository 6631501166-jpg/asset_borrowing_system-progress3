import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ===================== CONFIG =====================
  // ใช้ IP ที่ backend ขึ้นจริง (เช็คจาก console)
  static const String baseUrl = 'http://172.25.53.24:3000/api';

  // ===================== REGISTER =====================
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    String? phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'ph_num': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ===================== LOGIN =====================
  static Future<Map<String, dynamic>> login({
    String? email,
    String? username,
    String? uid,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {'password': password};

      if (email != null && email.isNotEmpty) {
        requestBody['email'] = email;
      } else if (username != null && username.isNotEmpty) {
        requestBody['username'] = username;
      } else if (uid != null && uid.isNotEmpty) {
        requestBody['uid'] = uid;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ===================== CATEGORIES =====================
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===================== ASSETS =====================
  static Future<List<Map<String, dynamic>>> fetchAssets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/assets'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load assets: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAssetsByCategory(
      int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/assets/category/$categoryId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load assets: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===================== BORROW REQUEST =====================
  static Future<Map<String, dynamic>> submitBorrowRequest({
    required int borrowerId,
    required int assetId,
    required String borrowDate,
    required String returnDate,
  }) async {
    try {
      final requestBody = {
        'borrower_id': borrowerId,
        'asset_id': assetId,
        'borrow_date': borrowDate,
        'return_date': returnDate,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/student/borrow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ===================== STUDENT REQUESTS =====================
  static Future<List<Map<String, dynamic>>> fetchStudentRequests(
      int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/requests/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load requests: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===================== PLACEHOLDERS =====================
  static Future updateProfile(Map<String, String> data) async {
    return {'success': false, 'message': 'Not implemented'};
  }

  static Future<Map<String, dynamic>> fetchLecturerProfile() async {
    return {'success': false, 'message': 'Not implemented'};
  }

  static Future<List<Map<String, dynamic>>> fetchApprovalHistory(
      int lecturerId) async {
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchBorrowRequestsForLecturer()
      async {
    return [];
  }

  static Future approveBorrowRequest(int borrowingId) async {
    return {'success': false, 'message': 'Not implemented'};
  }

  static Future rejectBorrowRequest(int borrowingId, String reason) async {
    return {'success': false, 'message': 'Not implemented'};
  }

  static Future<Map<String, dynamic>> fetchLecturerDashboard() async {
    return {'success': false, 'message': 'Not implemented'};
  }

  static Future<Map<String, dynamic>> fetchSettings() async {
    return {'success': false, 'message': 'Not implemented'};
  }

  static Future<void> updateSettings(Map<String, bool> map) async {
    return;
  }

  static Future deleteAccount() async {
    return {'success': false, 'message': 'Not implemented'};
  }
}
