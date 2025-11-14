import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

class BorrowAssetPage extends StatefulWidget {
  const BorrowAssetPage({super.key});

  @override
  State<BorrowAssetPage> createState() => _BorrowAssetPageState();
}

class _BorrowAssetPageState extends State<BorrowAssetPage> {
  DateTime? fromDate;
  DateTime? toDate;
  int _selectedIndex = 0;
  bool _isSubmitting = false;
  String? _userName;
  
  // Asset info from navigation arguments
  int? _assetId;
  String _assetCode = '';
  String _assetName = '';
  String _categoryName = '';
  String? _imageUrl;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firstName = await SessionManager.getFirstName();
    final lastName = await SessionManager.getLastName();
    setState(() {
      _userName = '$firstName $lastName'.trim();
      if (_userName!.isEmpty) {
        _userName = 'Student';
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get asset info from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _assetId = args['assetId'] as int?;
      _assetCode = args['id'] as String? ?? '';
      _assetName = args['name'] as String? ?? '';
      _categoryName = args['categoryName'] as String? ?? '';
      _imageUrl = args['imageUrl'] as String?;
    }
  }

  // Get icon based on category name
  IconData _getCategoryIcon() {
    final lowerName = _categoryName.toLowerCase();
    if (lowerName.contains('macbook') || lowerName.contains('laptop')) {
      return Icons.laptop_mac;
    } else if (lowerName.contains('ipad') || lowerName.contains('tablet')) {
      return Icons.tablet_mac;
    } else if (lowerName.contains('playstation') || lowerName.contains('ps')) {
      return Icons.sports_esports;
    } else if (lowerName.contains('vr') || lowerName.contains('headset')) {
      return Icons.vrpano;
    } else if (lowerName.contains('camera')) {
      return Icons.camera_alt;
    } else if (lowerName.contains('drone')) {
      return Icons.flight;
    } else {
      return Icons.devices;
    }
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

  Future<void> selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> saveRequest() async {
    // Validation
    if (_assetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Asset not selected'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Please select both dates'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (toDate!.isBefore(fromDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Return date must be after borrow date'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get logged-in user ID from session
      final userId = await SessionManager.getUserId();
      
      print('🔍 Debug - Borrow Request Data:');
      print('   User ID: $userId');
      print('   Asset ID: $_assetId');
      print('   Asset Code: $_assetCode');
      print('   From Date: ${fromDate != null ? formatter.format(fromDate!) : "null"}');
      print('   To Date: ${toDate != null ? formatter.format(toDate!) : "null"}');
      
      if (userId == null) {
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
        
        // Navigate to login
        Navigator.pushReplacementNamed(context, '/student-login');
        return;
      }
      
      final result = await ApiService.submitBorrowRequest(
        borrowerId: userId, // Use actual logged-in student ID from session
        assetId: _assetId!,
        borrowDate: formatter.format(fromDate!),
        returnDate: formatter.format(toDate!),
      );

      setState(() {
        _isSubmitting = false;
      });

      if (result['success'] == true) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Borrow request submitted successfully'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to asset list after 1 second
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/student-assets');
      } else {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(result['message'] ?? 'Failed to submit request'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text('Error: ${e.toString()}'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
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

            // Title
            const Text(
              'Borrow Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            // Main Content Card
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF0C1851),
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 20),

                      // Asset Card - Modern Design
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1a2b5a),
                              Color(0xFF0C1851),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0C1851).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Asset Image or Icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: _imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        _imageUrl!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            _getCategoryIcon(),
                                            color: Colors.white,
                                            size: 60,
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      _getCategoryIcon(),
                                      color: Colors.white,
                                      size: 60,
                                    ),
                            ),
                            const SizedBox(height: 20),

                            // Asset Name
                            Text(
                              _assetName.isNotEmpty ? _assetName : 'Asset',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // Asset Code Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ID: ${_assetCode.isNotEmpty ? _assetCode : 'N/A'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Date Selection Section
                      const Text(
                        'Select Borrow Period',
                        style: TextStyle(
                          color: Color(0xFF0C1851),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // From Date Card
                      _buildDateCard(
                        label: 'From Date',
                        date: fromDate,
                        icon: Icons.calendar_today_outlined,
                        onTap: () => selectDate(context, true),
                      ),
                      const SizedBox(height: 16),

                      // To Date Card
                      _buildDateCard(
                        label: 'Return Date',
                        date: toDate,
                        icon: Icons.event_outlined,
                        onTap: () => selectDate(context, false),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : saveRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            elevation: _isSubmitting ? 0 : 8,
                            shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, size: 24),
                                    SizedBox(width: 8),
                                    Text(
                                      'Submit Request',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
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

  // Build Date Selection Card
  Widget _buildDateCard({
    required String label,
    required DateTime? date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: date != null ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: date != null 
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: date != null ? const Color(0xFF4CAF50) : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null ? formatter.format(date) : 'Tap to select',
                    style: TextStyle(
                      color: date != null ? const Color(0xFF0C1851) : Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
