// ==========================================
// File: lib/student/asset_menu.dart
// Dynamic asset list by category
// ==========================================
import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

class StudentAssetMenu extends StatefulWidget {
  const StudentAssetMenu({super.key});

  @override
  State<StudentAssetMenu> createState() => _StudentAssetMenuState();
}

class _StudentAssetMenuState extends State<StudentAssetMenu> {
  int _selectedIndex = 0;
  List<Asset> _assets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _userName;
  int? _categoryId;
  String _categoryName = '';

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
    // Get category info from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _categoryId = args['categoryId'] as int?;
      _categoryName = args['name'] as String? ?? '';
      if (_categoryId != null) {
        _fetchAssets();
      }
    }
  }

  Future<void> _fetchAssets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.fetchAssetsByCategory(_categoryId!);
      setState(() {
        _assets = data.map((json) => Asset.fromJson(json)).toList();
        _isLoading = false;
      });
      
      print('✅ Loaded ${_assets.length} assets for category $_categoryName');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('❌ Error loading assets: $e');
    }
  }

  void _onItemTapped(int index) {
    // Navigate using student routes defined in main.dart
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
      case 2: // Home -> go to assets list
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
      backgroundColor: const Color.fromARGB(255, 12, 24, 81),
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
              'Asset List',
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Color.fromARGB(255, 12, 24, 81),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Asset List - $_categoryName',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 12, 24, 81),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _buildContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Default bottom navbar style you’re using everywhere
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

  // Build content based on loading state
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1a2b5a)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading assets',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchAssets,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1a2b5a),
              ),
            ),
          ],
        ),
      );
    }

    if (_assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              'No assets available',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no $_categoryName assets at the moment',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAssets,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assets.length,
        itemBuilder: (context, index) {
          final asset = _assets[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < _assets.length - 1 ? 12 : 0),
            child: InkWell(
              onTap: asset.isAvailable
                  ? () {
                      Navigator.pushNamed(
                        context,
                        '/student-borrow',
                        arguments: {
                          'id': asset.assetCode,
                          'name': asset.assetName,
                          'assetId': asset.assetId,
                          'categoryName': asset.categoryName,
                          'imageUrl': asset.getImageUrl(),
                        },
                      );
                    }
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: _buildAssetCard(asset),
            ),
          );
        },
      ),
    );
  }

  // Build individual asset card
  Widget _buildAssetCard(Asset asset) {
    final imageUrl = asset.getImageUrl();
    final statusColor = asset.getStatusColor();
    final isDisabled = !asset.isAvailable;
    final Color backgroundColor = isDisabled
        ? const Color.fromARGB(255, 100, 100, 100)
        : const Color(0xFF1a2b5a);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category image
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 32,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.assetName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${asset.assetCode}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  asset.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
