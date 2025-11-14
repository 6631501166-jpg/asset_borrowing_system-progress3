import 'package:flutter/material.dart';
import 'package:asset_borrowing_system/services/api_service.dart';


class LenderHistory extends StatefulWidget {
  const LenderHistory({super.key});

  @override
  State<LenderHistory> createState() => _LenderHistoryState();
}

class _LenderHistoryState extends State<LenderHistory> {
  int _selectedIndex = 1;

  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;
  String _query = '';

  final TextEditingController _searchController = TextEditingController();

  // 👇 ใช้ uid ของ lecturer แบบ fix ไว้ก่อน
  // ดูจาก /api/debug/users หรือจากข้อมูล login ว่า uid เป็นเลขอะไร
  // ถ้า lecturer01@example.com = uid 13 ก็ใช้ 13 ตรงนี้
  static const int _lecturerId = 12;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
  try {
    const lecturerId = 12; // ชั่วคราว ใช้ตรง ๆ ก่อน
    final data = await ApiService.fetchApprovalHistory(lecturerId);
//     print('DEBUG history length = ${data.length}');
//     print('DEBUG first item = ${data.isNotEmpty ? data.first : 'none'}');

    setState(() {
      _history = data;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load history: $e')),
    );
  }
}

  IconData _getIconForTitle(String title) {
    String lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('playstation')) return Icons.sports_esports_outlined;
    if (lowerTitle.contains('vr')) return Icons.vrpano_outlined;
    if (lowerTitle.contains('ipad')) return Icons.tablet_mac_outlined;
    if (lowerTitle.contains('mac')) return Icons.laptop_mac_outlined;
    return Icons.device_unknown_outlined;
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
        // อยู่หน้า History แล้ว
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/lecturer-profile');
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _history.where((item) {
      String title = item['asset_name'] ?? '';
      return title.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Header =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
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
            ),
            const Text(
              'Lender History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // ===== White Panel =====
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
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: SizedBox(
                        height: 35,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Search History',
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

                    // List
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filtered.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 0, 16, 12),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final item = filtered[index];

                                    String title =
                                        item['asset_name'] ?? 'Unknown';
                                    String id = item['asset_code'] ??
                                        item['asset_id']?.toString() ??
                                        'Unknown';
                                    String from =
                                        item['borrow_date'] ?? 'Unknown';
                                    String to =
                                        item['return_date'] ?? 'Unknown';
                                    String borrower =
                                        item['borrower_name'] ?? 'Unknown';
                                    String status =
                                        item['status'] ?? 'Approved';

                                    Color statusColor;
                                    if (status.toLowerCase() == 'rejected') {
                                      statusColor = Colors.red;
                                    } else if (status.toLowerCase() ==
                                        'returned') {
                                      statusColor = Colors.blue;
                                    } else {
                                      statusColor = Colors.green;
                                    }

                                    IconData icon = _getIconForTitle(title);

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: _buildHistoryCard(
                                        icon: icon,
                                        title: title,
                                        id: id,
                                        from: from,
                                        to: to,
                                        borrower: borrower,
                                        status: status,
                                        statusColor: statusColor,
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== Bottom Nav =====
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

  Widget _buildHistoryCard({
    required IconData icon,
    required String title,
    required String id,
    required String from,
    required String to,
    required String borrower,
    required String status,
    required Color statusColor,
  }) {
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
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'From: $from',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'To: $to',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Borrower: $borrower',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 120,
              color: Colors.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            const Text(
              'No history found yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/requests');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1a2b5a),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Go to requests',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
