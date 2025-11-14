// ==========================================
// File: lib/student/borrower_history.dart
// ==========================================
import 'package:flutter/material.dart';
import '../services/session_manager.dart';

class BorrowerHistory extends StatefulWidget {
  const BorrowerHistory({super.key});

  @override
  State<BorrowerHistory> createState() => _BorrowerHistoryState();
}

class _BorrowerHistoryState extends State<BorrowerHistory> {
  int _selectedIndex = 1; // History tab selected
  String? _userName;

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

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0: // Assets - go back to main asset list
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-assets',
          (route) => false,
        );
        break;
      case 1:
        // stay on History
        break;
      case 2: // Home - go to assets list
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-assets',
          (route) => false,
        );
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/student-profile');
        break;
    }
  }

  Color _statusColor(String s) {
    final st = s.toLowerCase();
    if (st == 'rejected') return Colors.red;
    if (st == 'borrowing') return Colors.orange;
    // approved / returned -> green
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> historyItems = <Map<String, dynamic>>[
      {
        "name": "PlayStation 5",
        "id": "PS5-1",
        "from": "16 Nov 2025",
        "to": "19 Nov 2025",
        "approvedBy": "Min",
        "status": "Approved",
        "icon": Icons.sports_esports_outlined,
      },
      {
        "name": "iPad Pro M4",
        "id": "iPad-1",
        "from": "2 Nov 2025",
        "to": "5 Nov 2025",
        "approvedBy": "Aj.Paweena",
        "status": "Returned",
        "icon": Icons.tablet_mac_outlined,
      },
      {
        "name": "Macbook Air M3",
        "id": "Mac-1",
        "from": "16 Oct 2025",
        "to": "18 Oct 2025",
        "approvedBy": "Aj.Surapong",
        "status": "Returned",
        "icon": Icons.laptop_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0C1C64),

      // ▼ Default bottom navbar you requested
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

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello ${_userName ?? "Student"}!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                ],
              ),
            ),

            // Title
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Text(
                  "Borrower History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // History List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: historyItems.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: historyItems.length,
                        itemBuilder: (context, index) {
                          final item = historyItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E1939),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row: icon + name + id
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1C2A54),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item["name"].toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Text(
                                            "ID: ${item["id"]}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Row: dates + status
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "From: ${item["from"]}\nTo: ${item["to"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.5,
                                        height: 1.4,
                                      ),
                                    ),
                                    Text(
                                      item["status"].toString(),
                                      style: TextStyle(
                                        color: _statusColor(item["status"]!),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Approved by
                                
                                const SizedBox(height: 6),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/searchIcon.png", width: 220, height: 220),
          const SizedBox(height: 28),
          const Text(
            "No history found yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Activity of your assets will appear.",
            style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C1C64),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Go to assets",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
