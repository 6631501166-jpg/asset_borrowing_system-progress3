// ==========================================
// File: lib/staff/staff_history.dart
// ==========================================
import 'package:flutter/material.dart';

class StaffHistory extends StatefulWidget {
  const StaffHistory({super.key});

  @override
  State<StaffHistory> createState() => _StaffHistoryState();
}

class _StaffHistoryState extends State<StaffHistory> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // avoid redundant rebuilds
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/staff-assets');
        break;
      case 1:
        // stay here
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/staff-home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/staff-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> historyItems = <Map<String, String?>>[
      {
        "name": "PlayStation 5",
        "id": "PS5-1",
        "from": "16 Nov 2025",
        "to": "19 Nov 2025",
        "borrowedBy": "Min",
        "approvedBy": "Aj.God",
        "status": "Borrowing",
      },
      {
        "name": "Macbook Pro M2",
        "id": "Mac-2",
        "from": "14 Nov 2025",
        "to": "16 Nov 2025",
        "borrowedBy": "Joy",
        "returnedBy": "Joy",
        "approvedBy": "Aj.King",
        "status": "Returned",
      },
      {
        "name": "iPad Air M2",
        "id": "iPad-2",
        "from": "1 Nov 2025",
        "to": "18 Nov 2025",
        "borrowedBy": "Ray",
        "approvedBy": "Aj.Fon",
        "status": "Borrowing",
      },
    ];

    return Scaffold(
      // 🔵 Change: match background to card color
      backgroundColor: const Color(0xFF0E1939),

      // ✅ Default bottom navbar (your requested config)
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
                children: const [
                  Text(
                    "Hello John Smith!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Icon(Icons.notifications_none, color: Colors.white, size: 26),
                ],
              ),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: Text(
                  "Staff History",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: historyItems.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: historyItems.length,
                        itemBuilder: (context, index) {
                          final item = historyItems[index];
                          final isBorrowing = item["status"] == "Borrowing";
                          final Color statusColor =
                              isBorrowing ? Colors.orange : Colors.green;

                          return Container(
                            // 🔻 Make cards look smaller
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E1939),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row: icon, name, id
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1C2A54),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        _iconForItem(item['name'] ?? ''),
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item["name"] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18, // ↓ from 20
                                                fontWeight: FontWeight.w700,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "ID: ${item["id"]}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14, // ↓ from 17
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
                                        fontSize: 14.5, // ↓ from 16.5
                                        height: 1.4,
                                      ),
                                    ),
                                    Text(
                                      item["status"] ?? '',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16, // ↓ from 18
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Row: borrowed/returned by + approved by
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Borrowed By: ${item['borrowedBy']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.5, // ↓ from 16.5
                                            height: 1.4,
                                          ),
                                        ),
                                        if ((item['returnedBy'] ?? '')
                                            .toString()
                                            .isNotEmpty)
                                          Text(
                                            "Returned By: ${item['returnedBy']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.5, // ↓
                                              height: 1.4,
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      "Approved by: ${item["approvedBy"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12, // ↓ from 13.5
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
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

  // WHY: simple robust mapping by name keywords.
  IconData _iconForItem(String name) {
    final n = name.toLowerCase();
    if (n.contains('playstation') || n.contains('ps')) {
      return Icons.sports_esports;
    }
    if (n.contains('mac') || n.contains('laptop')) {
      return Icons.laptop_mac;
    }
    if (n.contains('ipad') || n.contains('tablet')) {
      return Icons.tablet_mac;
    }
    return Icons.devices_other;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 120, color: Color(0xFF0C1C64)),
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
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/staff-assets'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C1C64),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              elevation: 0,
            ),
            child: const Text("Go to assets",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
