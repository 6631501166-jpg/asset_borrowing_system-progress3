import 'package:flutter/material.dart';
import 'package:asset_borrowing_system/services/api_service.dart';

class LecturerAssetMenu extends StatefulWidget {
  const LecturerAssetMenu({super.key});

  @override
  State<LecturerAssetMenu> createState() => _LecturerAssetMenuState();
}

class _LecturerAssetMenuState extends State<LecturerAssetMenu> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> _assetDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssetDetails();
  }

  Future<void> _fetchAssetDetails() async {
    try {
      // Assume categoryId for Macbook is 1; adjust based on actual category ID from backend
      const int categoryId = 1; // Change this to the actual Macbook category ID
      final List<Map<String, dynamic>> apiAssets = await ApiService.fetchAssetsByCategory(categoryId);
      setState(() {
        _assetDetails = apiAssets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load asset details: $e')));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/assets');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
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
            // Header aligned/styled like default
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Hello Aj.Surapong!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 22, // default size
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
                // Default background sheet settings
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Asset List Macbook',
                            style: TextStyle(
                              color: Color.fromARGB(255, 12, 24, 81),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: _assetDetails.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, i) {
                                  final a = _assetDetails[i];
                                  String title = a['asset_name'] ?? a['name'] ?? 'Unknown';
                                  String id = a['asset_id']?.toString() ?? a['id']?.toString() ?? 'Unknown';
                                  String status = a['status'] ?? 'Available';
                                  Color statusColor;
                                  switch (status.toLowerCase()) {
                                    case 'pending':
                                      statusColor = const Color.fromARGB(255, 253, 244, 85);
                                      break;
                                    case 'disable':
                                    case 'disabled':
                                      statusColor = const Color.fromARGB(255, 255, 64, 64);
                                      break;
                                    case 'borrowed':
                                      statusColor = const Color(0xFFFFB020);
                                      break;
                                    default:
                                      statusColor = const Color.fromRGBO(76, 175, 80, 1);
                                  }
                                  return requestCard(
                                    icon: Icons.laptop_outlined,
                                    title: title,
                                    id: id,
                                    status: status,
                                    statusColor: statusColor,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
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

  Widget requestCard({
    required IconData icon,
    required String title,
    required String id,
    required String status,
    required Color statusColor,
  }) {
    Color backgroundColor = (status.toLowerCase() == 'disable' || status.toLowerCase() == 'disabled')
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $id',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
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
