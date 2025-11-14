// ==========================================
// File: lib/student/asset_list.dart
// StudentAssetList (Figma-style) - Dynamic
// ==========================================
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../models/category_model.dart';

class StudentAssetList extends StatefulWidget {
  const StudentAssetList({super.key});

  @override
  State<StudentAssetList> createState() => _StudentAssetListState();
}

class _StudentAssetListState extends State<StudentAssetList> {
  int _selectedIndex = 0;
  final TextEditingController _search = TextEditingController();
  String? _userName;
  
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchCategories();
    _search.addListener(_filterCategories);
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

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔄 Fetching categories from API...');
      final data = await ApiService.fetchCategories();
      print('✅ Received ${data.length} categories');
      
      final categories = data.map((json) => Category.fromJson(json)).toList();
      print('📦 Categories: ${categories.map((c) => c.name).join(', ')}');
      
      setState(() {
        _categories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching categories: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterCategories() {
    final query = _search.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where((category) => category.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        // Already on assets page - do nothing or reload
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/student-history');
        break;
      case 2:
        // Home - refresh current page
        _fetchCategories();
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/student-profile');
        break;
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      body: SafeArea(
        child: Column(
          children: [
            // Header (greeting + bell)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
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
                  Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                ],
              ),
            ),

            // Centered title
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Asset List',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // Inner rounded sheet
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    // Rounded search header (pill inside a soft container)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E7EB),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: SizedBox(
                          height: 40,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: _search,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintText: 'Search Asset',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF1a2b5a),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 0,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              // circular search icon at right (as in Figma)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1a2b5a),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.search, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Cards + floating "Check Requests"
                    Expanded(
                      child: Stack(
                        children: [
                          // Loading, Error, or Content
                          _buildContent(),

                          // Floating "Check Requests" pill
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/student-requests'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1a2b5a),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                shape: const StadiumBorder(),
                                elevation: 3,
                                shadowColor: const Color(0x33000000),
                              ),
                              child: const Text('Check Requests', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom nav — uses existing student routes
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1a2b5a),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Build content based on loading/error/data state
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Error loading categories',
                style: TextStyle(
                  color: Color(0xFF1a2b5a),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1a2b5a),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              _search.text.isEmpty ? 'No categories available' : 'No matching categories',
              style: const TextStyle(
                color: Color(0xFF1a2b5a),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCategories,
      color: const Color(0xFF1a2b5a),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          final category = _filteredCategories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildCategoryCard(category),
          );
        },
      ),
    );
  }

  // Build individual category card
  Widget _buildCategoryCard(Category category) {
    final isDisabled = category.isDisabled;
    final imageUrl = category.getImageUrl();
    
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🎨 Building card for: ${category.name}');
    print('📁 Image filename: ${category.image}');
    print('🌐 Full URL: $imageUrl');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    return InkWell(
      onTap: isDisabled ? null : () {
        // Navigate to asset menu with category info
        Navigator.pushNamed(
          context,
          '/student-asset-menu',
          arguments: {
            'categoryId': category.categoryId,
            'name': category.name,
          },
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: _assetCard(
        title: category.name,
        status: isDisabled ? 'Disable' : 'Available',
        statusColor: isDisabled ? const Color(0xFFD32F2F) : const Color(0xFF4CAF50),
        isDisabled: isDisabled,
        imageUrl: imageUrl,
      ),
    );
  }

  // Reusable card styled to match the screenshot
  Widget _assetCard({
    required String title,
    required String status,
    required Color statusColor,
    required bool isDisabled,
    String? imageUrl,
  }) {
    final Color bg = isDisabled ? const Color(0xFF8D8D92) : const Color(0xFF132552);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Use image from backend, fallback to icon
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Show placeholder if image fails to load
                        print('❌ Image failed to load: $imageUrl');
                        print('Error: $error');
                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: 32,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          print('✅ Image loaded: $imageUrl');
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: isDisabled ? const Color(0xFFB71C1C) : statusColor,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
