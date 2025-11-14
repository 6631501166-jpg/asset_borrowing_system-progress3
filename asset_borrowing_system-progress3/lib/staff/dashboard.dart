// ==========================================
// File: lib/staff/dashboard.dart
// ==========================================
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2; // Home selected by default

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/staff-assets');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/staff-history');
        break;
      case 2:
        break; // stay here
      case 3:
        Navigator.pushReplacementNamed(context, '/staff-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Hello John Smith!',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text('Dashboard',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 32),
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
                      value: '50',
                      label: 'Total Assets',
                      iconColor: const Color(0xFF1A237E),
                      iconBackground: const Color(0xFFE8EAF6),
                      onTap: () => Navigator.pushNamed(context, '/staff-assets'),
                    ),
                    const StatCard(
                      icon: Icons.check_circle_outline,
                      value: '30',
                      label: 'Available',
                      iconColor: Color(0xFF2E7D32),
                      iconBackground: Color(0xFFE8F5E9),
                    ),
                    const StatCard(
                      icon: Icons.cancel_outlined,
                      value: '5',
                      label: 'Disabled',
                      iconColor: Color(0xFFC62828),
                      iconBackground: Color(0xFFFFEBEE),
                    ),
                    StatCard(
                      icon: Icons.arrow_forward,
                      value: '15',
                      label: 'Borrowed',
                      iconColor: const Color(0xFFEF6C00),
                      iconBackground: const Color(0xFFFFF3E0),
                      onTap: () => Navigator.pushNamed(context, '/staff-history'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Available Assets',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: AssetItem(icon: Icons.laptop_mac, label: 'Macbook')),
                        SizedBox(width: 40),
                        Expanded(child: AssetItem(icon: Icons.tablet_mac, label: 'iPad')),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: AssetItem(icon: Icons.sports_esports, label: 'PlayStation')),
                        SizedBox(width: 40),
                        Expanded(child: AssetItem(icon: Icons.vrpano_outlined, label: 'VR Headset')),
                      ],
                    ),
                  ],
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
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value, style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 24, fontWeight: FontWeight.bold, height: 1.0)),
                  const SizedBox(height: 4),
                  Text(label, style: const TextStyle(color: Color(0xFF757575), fontSize: 12, fontWeight: FontWeight.w500)),
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
  const AssetItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
