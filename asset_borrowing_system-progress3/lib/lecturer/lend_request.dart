import 'package:flutter/material.dart';
import 'package:asset_borrowing_system/services/api_service.dart';

class LendRequest extends StatefulWidget {
  const LendRequest({super.key});

  @override
  State<LendRequest> createState() => _LendRequestState();
}

class _LendRequestState extends State<LendRequest> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;
  String _query = '';

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final List<Map<String, dynamic>> apiRequests = await ApiService.fetchBorrowRequestsForLecturer();
      setState(() {
        _requests = apiRequests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load requests: $e')));
    }
  }

  IconData _getIconForTitle(String title) {
    String lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('macbook')) return Icons.laptop_outlined;
    if (lowerTitle.contains('ipad')) return Icons.tablet_mac_outlined;
    if (lowerTitle.contains('vr')) return Icons.vrpano_outlined;
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

  Future<void> _handleApprove(int borrowingId, String assetName, String id) async {
    final result = await ApiService.approveBorrowRequest(borrowingId, lecturerId: 12,);
    if (result['success']) {
      _showApproveDialog('Approved', 'Request for $assetName ($id) has been approved.');
      _fetchRequests(); // Refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Future<void> _handleReject(int borrowingId, String assetName, String id) async {
    String? reason = await _showRejectReasonDialog();
    if (reason != null && reason.isNotEmpty) {
      final result = await ApiService.rejectBorrowRequest(borrowingId, reason, lecturerId: 12,);
      if (result['success']) {
        _showRejectDialog('Rejected', 'Request for $assetName ($id) has been rejected.');
        _fetchRequests(); // Refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  // ---------- Dialogs ----------
  Future<void> _showApproveDialog(String title, String message) {
    return _showDecisionDialog(
      title: title,
      message: message,
      circleBg: const Color(0xFFEAF7EF),
      accent: const Color(0xFF22B14C),
      icon: Icons.check_circle_rounded,
    );
  }

  Future<void> _showRejectDialog(String title, String message) {
    return _showDecisionDialog(
      title: title,
      message: message,
      circleBg: const Color(0xFFFFEBEE),
      accent: const Color(0xFFE53935),
      icon: Icons.cancel_rounded,
    );
  }

  Future<String?> _showRejectReasonDialog() async {
    _reasonController.clear();
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reject Reason'),
          content: TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: 'Enter reason for rejection'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(_reasonController.text),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDecisionDialog({
    required String title,
    required String message,
    required Color circleBg,
    required Color accent,
    required IconData icon,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 40),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0C1851),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF44506B),
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1a2b5a),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  // ---------- End dialogs ----------

  @override
  void dispose() {
    _searchController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _requests.where((r) {
      String title = r['asset_name'] ?? '';
      return title.toLowerCase().contains(_query.toLowerCase());
    }).toList();

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
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Hello Aj.Surapong!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
              'Lend Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          height: 35,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
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
                      const SizedBox(height: 12),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, i) {
                                  final r = filtered[i];
                                  String title = r['asset_name'] ?? 'Unknown';
                                  String id = r['asset_id']?.toString() ?? 'Unknown';
                                  String from = r['borrow_date'] ?? 'Unknown';
                                  String to = r['return_date'] ?? 'Unknown';
                                  String status = r['status'] ?? 'Pending';
                                  Color statusColor = const Color(0xFFFFB020); // Default pending
                                  int borrowingId = r['borrowing_id'] ?? 0;
                                  return _buildRequestCard(
                                    icon: _getIconForTitle(title),
                                    title: title,
                                    id: id,
                                    from: from,
                                    to: to,
                                    status: status,
                                    statusColor: statusColor,
                                    borrowingId: borrowingId,
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

  Widget _buildRequestCard({
    required IconData icon,
    required String title,
    required String id,
    required String from,
    required String to,
    required String status,
    required Color statusColor,
    required int borrowingId,
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
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _handleApprove(borrowingId, title, id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22B14C),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(88, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _handleReject(borrowingId, title, id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(88, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
