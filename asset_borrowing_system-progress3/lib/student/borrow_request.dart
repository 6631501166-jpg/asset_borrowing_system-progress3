// ==========================================
// File: lib/student/borrow_request.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../models/borrow_request_model.dart';

class StudentBorrowRequests extends StatefulWidget {
  const StudentBorrowRequests({super.key});

  @override
  State<StudentBorrowRequests> createState() => _StudentBorrowRequestsState();
}

class _StudentBorrowRequestsState extends State<StudentBorrowRequests> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<BorrowRequest> _requests = [];
  List<BorrowRequest> _filteredRequests = [];
  String _searchQuery = '';
  String? _userName;
  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRequests();
  }

  Future<void> _loadUserData() async {
    final fullName = await SessionManager.getFullName();
    setState(() {
      _userName = fullName;
    });
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await SessionManager.getUserId();
      
      if (userId == null || userId == 0) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Session expired. Please login again.'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
        
        Navigator.pushReplacementNamed(context, '/student-login');
        return;
      }

      final data = await ApiService.fetchStudentRequests(userId);
      
      setState(() {
        _requests = data.map((json) => BorrowRequest.fromJson(json)).toList();
        _filteredRequests = _requests;
        _isLoading = false;
      });
      
      print('✅ Loaded ${_requests.length} borrow requests');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Error loading requests: $e')),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterRequests(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredRequests = _requests;
      } else {
        _filteredRequests = _requests.where((request) {
          return request.assetName.toLowerCase().contains(query.toLowerCase()) ||
                 request.assetCode.toLowerCase().contains(query.toLowerCase()) ||
                 request.categoryName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0: // Assets - go back to main asset list
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-assets',
          (route) => false,
        );
        break;
      case 1: // History
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-history',
          (route) => false,
        );
        break;
      case 2: // Home - go to assets list
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-assets',
          (route) => false,
        );
        break;
      case 3: // Profile
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-profile',
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello ${_userName ?? "Student"}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Request Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            onChanged: _filterRequests,
                            decoration: InputDecoration(
                              hintText: 'Search Asset',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1a2b5a),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 0,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1a2b5a),
                              ),
                            )
                          : _filteredRequests.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _searchQuery.isEmpty
                                            ? 'No borrow requests yet'
                                            : 'No requests found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      if (_searchQuery.isEmpty) ...[
                                        const SizedBox(height: 8),
                                        TextButton.icon(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/student-assets');
                                          },
                                          icon: const Icon(Icons.add),
                                          label: const Text('Borrow an Asset'),
                                        ),
                                      ],
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _loadRequests,
                                  color: const Color(0xFF1a2b5a),
                                  child: ListView.separated(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                    itemCount: _filteredRequests.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final request = _filteredRequests[index];
                                      return _buildRequestCard(request);
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1a2b5a),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Assets',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BorrowRequest request) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2b5a),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Use actual image from API instead of icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: request.getFixedImageUrl().isNotEmpty
                  ? Image.network(
                      request.getFixedImageUrl(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image fails to load
                        return Icon(
                          request.getCategoryIcon(),
                          color: Colors.white,
                          size: 28,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        );
                      },
                    )
                  : Icon(
                      request.getCategoryIcon(),
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.assetName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${request.assetCode}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'From: ${_dateFormatter.format(request.borrowDate)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'To: ${_dateFormatter.format(request.returnDate)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            request.getStatusDisplay(),
            style: TextStyle(
              color: request.getStatusColor(),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
