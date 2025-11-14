// ==========================================
// File: lib/lecturer/dashboard.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:asset_borrowing_system/services/api_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2; // Home tab

  Map<String, dynamic> _dashboardStats = {};
  List<Map<String, dynamic>> _availableAssets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
  try {
    const int lecturerId = 12; // ชั่วคราว
    final stats = await ApiService.fetchLecturerDashboard(lecturerId);

      final List<Map<String, dynamic>> categories =
          await ApiService.fetchCategories();

      setState(() {
        _dashboardStats = stats;
        _availableAssets = categories;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dashboard: $e')),
        );
      }
    }
  }

  IconData _getIconForLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('macbook')) return Icons.laptop_mac;
    if (lower.contains('ipad')) return Icons.tablet_mac;
    if (lower.contains('playstation')) return Icons.sports_esports;
    if (lower.contains('vr')) return Icons.vrpano_outlined;
    return Icons.device_unknown;
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
        // home
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/lecturer-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String totalAssets =
        _dashboardStats['total_assets']?.toString() ?? '0';
    final String available =
        _dashboardStats['available']?.toString() ?? '0';
    final String disabled =
        _dashboardStats['disabled']?.toString() ?? '0';
    final String borrowed =
        _dashboardStats['borrowed']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hello Aj.Surapong!',
                            style: TextStyle(
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
                      const SizedBox(height: 24),

                      const Center(
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Stat cards
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          StatCard(
                            icon: Icons.inventory_2_outlined,
                            value: totalAssets,
                            label: 'Total Assets',
                            iconColor: const Color(0xFF1A237E),
                            iconBackground: const Color(0xFFE8EAF6),
                            onTap: () {
                              Navigator.pushNamed(context, '/assets');
                            },
                          ),
                          StatCard(
                            icon: Icons.check_circle_outline,
                            value: available,
                            label: 'Available',
                            iconColor: const Color(0xFF2E7D32),
                            iconBackground: const Color(0xFFE8F5E9),
                          ),
                          StatCard(
                            icon: Icons.cancel_outlined,
                            value: disabled,
                            label: 'Disabled',
                            iconColor: const Color(0xFFC62828),
                            iconBackground: const Color(0xFFFFEBEE),
                          ),
                          StatCard(
                            icon: Icons.arrow_forward,
                            value: borrowed,
                            label: 'Borrowed',
                            iconColor: const Color(0xFFEF6C00),
                            iconBackground: const Color(0xFFFFF3E0),
                            onTap: () {
                              Navigator.pushNamed(context, '/requests');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Available Assets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Column(
                        children: List.generate(
                          (_availableAssets.length / 2).ceil(),
                          (index) {
                            final int start = index * 2;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Row(
                                children: [
                                  if (start < _availableAssets.length)
                                    Expanded(
                                      child: AssetItem(
                                        icon: _getIconForLabel(
                                          _availableAssets[start]['name'] ??
                                              'Unknown',
                                        ),
                                        label: _availableAssets[start]['name'] ??
                                            'Unknown',
                                      ),
                                    ),
                                  const SizedBox(width: 40),
                                  if (start + 1 < _availableAssets.length)
                                    Expanded(
                                      child: AssetItem(
                                        icon: _getIconForLabel(
                                          _availableAssets[start + 1]['name'] ??
                                              'Unknown',
                                        ),
                                        label: _availableAssets[start + 1]
                                                ['name'] ??
                                            'Unknown',
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssetItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const AssetItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
