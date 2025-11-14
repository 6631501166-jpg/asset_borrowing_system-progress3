import 'package:flutter/material.dart';

class EditAsset extends StatefulWidget {
  const EditAsset({super.key});

  @override
  State<EditAsset> createState() => _EditAssetState();
}

const Color primaryDarkBlue = Color(0xFF0C1851);
const Color secondaryDarkBlue = Color(0xFF0C1851);

class _EditAssetState extends State<EditAsset> {
  int _selectedIndex = 0;
  int? _selectedIconGroup = 1;

  // ----- AppBar (Figma style) -----
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primaryDarkBlue,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // greeting (top-left)
          Text(
            'Hello John Smith!',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 4),
          // centered page title
          Center(
            child: Text(
              'Edit Assets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 14.0),
          child:
              Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
        ),
      ],
      toolbarHeight: 92,
    );
  }

  // ----- Bottom navigation (uses named routes from your snippet) -----
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0: // Assets
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/staff-assets',
          (r) => false,
        );
        break;
      case 1: // History
        Navigator.pushReplacementNamed(context, '/staff-history');
        break;
      case 2: // Home
        Navigator.pushReplacementNamed(context, '/staff-home');
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, '/staff-profile');
        break;
    }
  }

  BottomNavigationBarItem _buildNavItem(String label, IconData iconData) {
    return BottomNavigationBarItem(
      icon: Icon(iconData, size: 22),
      label: label,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: secondaryDarkBlue,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        _buildNavItem('Assets', Icons.inventory_2_outlined),
        _buildNavItem('History', Icons.history),
        _buildNavItem('Home', Icons.home_filled),
        _buildNavItem('Profile', Icons.person),
      ],
    );
  }

  // ----- Inputs / controls -----
  InputDecoration _fieldDeco() => InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        hintText: '',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(7),
        ),
      );

  Widget _buildTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _fieldDeco(),
    );
  }

  // device option rows (radio + icon)
  Widget _radioWithIcon(int value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _selectedIconGroup,
          onChanged: (val) => setState(() => _selectedIconGroup = val),
          activeColor: Colors.white,
          fillColor: MaterialStateProperty.all(Colors.white),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Icon(icon, color: Colors.white, size: 22),
      ],
    );
  }

  // compact grey "+ Add icon" chip-button
  Widget _addIconChip() {
    return SizedBox(
      height: 30,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.black, size: 16),
        label: const Text(
          '+ Add icon',
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  // card header: small icon tile + asset name
  Widget _cardHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child:
              const Icon(Icons.laptop_outlined, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        const Text(
          'Macbook Air M3',
          style: TextStyle(
              color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  // ----- Page body -----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkBlue,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: secondaryDarkBlue, // dark inner card
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardHeader(),
                        const SizedBox(height: 12),

                        // Rename row
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'Rename',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField()),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ID row
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'ID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // icon option rows (two rows)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _radioWithIcon(1, Icons.laptop_outlined),
                            const SizedBox(width: 10),
                            _radioWithIcon(2, Icons.sports_esports_outlined),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _radioWithIcon(3, Icons.tablet_mac_outlined),
                            const SizedBox(width: 10),
                            _radioWithIcon(4, Icons.vrpano_outlined),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // add icon chip
                        Align(
                            alignment: Alignment.centerLeft,
                            child: _addIconChip()),
                        const SizedBox(height: 12),

                        // save / cancel small buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Save, then go back to assets list
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/staff-assets',
                                    (r) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0DA03B), // green
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/staff-assets',
                                    (r) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE53935), // red
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
