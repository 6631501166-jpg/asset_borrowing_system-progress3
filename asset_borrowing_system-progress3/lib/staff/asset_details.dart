import 'package:asset_borrowing_system/staff/edit_asset.dart';
import 'package:flutter/material.dart';
import 'asset_list.dart';

class SpecificAsset {
  final String name;
  final String id;
  final String status;

  SpecificAsset({required this.name, required this.id, required this.status});
}

class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

const Color primaryDarkBlue = Color(0xFF0C1851);

class _AssetDetailPageState extends State<AssetDetailPage> {
  int _selectedIndex = 0;

  final List<SpecificAsset> _assets = [
    SpecificAsset(name: 'Macbook Pro M1', id: 'Mac-1', status: 'Available'),
    SpecificAsset(name: 'Macbook Pro', id: 'Mac-2', status: 'Pending'),
    SpecificAsset(name: 'Macbook Pro', id: 'Mac-3', status: 'Disable'),
    SpecificAsset(name: 'Macbook Air M2', id: 'Mac-4', status: 'Borrowed'),
  ];

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primaryDarkBlue,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello Staff!',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Center(
            child: const Text(
              'Manage Asset List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        const SizedBox(width: 16),
      ],
      toolbarHeight: 100,
    );
  }

  BottomNavigationBarItem _buildNavItem(String label, IconData iconData) {
    return BottomNavigationBarItem(
      icon: Icon(iconData, size: 24),
      label: label,
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 20.0,
        top: 20.0,
        bottom: 10.0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: primaryDarkBlue,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Asset_list()),
              );
            },
          ),
          const SizedBox(width: 5),
          const Text(
            'Asset List Macbook',
            style: TextStyle(
              color: primaryDarkBlue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(SpecificAsset asset) {
    final bool isEnabled = asset.status != 'Disable';
    final Color cardColor = isEnabled ? primaryDarkBlue : Colors.grey.shade700;

    Color statusColor;
    switch (asset.status) {
      case 'Available':
        statusColor = const Color.fromARGB(255, 2, 103, 22);
        break;
      case 'Pending':
        statusColor = const Color.fromARGB(255, 225, 186, 13);
        break;
      case 'Disable':
        statusColor = const Color.fromARGB(255, 166, 0, 34);
        break;
      case 'Borrowed':
        statusColor = Colors.orangeAccent.shade400;
        break;
      default:
        statusColor = Colors.white;
    }

    Widget actionButton;
    if (asset.status == 'Available') {
      actionButton = ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 180, 12, 0),
        ),
        child: const Text('Disable', style: TextStyle(color: Colors.white)),
      );
    } else if (asset.status == 'Disable') {
      actionButton = ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 2, 118, 5),
        ),
        child: const Text('Enable', style: TextStyle(color: Colors.white)),
      );
    } else {
      actionButton = ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600),
        child: const Text('Disable', style: TextStyle(color: Colors.white70)),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.laptop_mac, color: Colors.white, size: 24),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID : ${asset.id}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    asset.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditAsset(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 77, 150, 223),
                    fixedSize: const Size(100, 36),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(width: 100, height: 36, child: actionButton),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkBlue,
      appBar: _buildAppBar(),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryDarkBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Asset_list()),
              (Route<dynamic> route) => false,
            );
          }
        },
        items: [
          _buildNavItem('Assets', Icons.inventory_2_outlined),
          _buildNavItem('History', Icons.history),
          _buildNavItem('Home', Icons.home_filled),
          _buildNavItem('Profile', Icons.person),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _buildHeaderRow(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      itemCount: _assets.length,
                      itemBuilder: (context, index) {
                        return _buildAssetCard(_assets[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
