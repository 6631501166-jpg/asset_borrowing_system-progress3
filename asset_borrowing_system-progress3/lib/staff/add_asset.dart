import 'package:flutter/material.dart';
import 'asset_list.dart';

class AddAsset extends StatefulWidget {
  const AddAsset({super.key});

  @override
  State<AddAsset> createState() => _AddAssetState();
}

const Color primaryDarkBlue = Color(0xFF0C1851);

class _AddAssetState extends State<AddAsset> {
  int _selectedIndex = 0;
  int? _selectedIconGroup = 1;

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primaryDarkBlue,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Hello Staff!',
            style: TextStyle(color: Colors.white, fontSize: 14), // was 16
          ),
          SizedBox(height: 4), // was 5
          Center(
            child: Text(
              'Add Assets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22, // was 24
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 14.0),
          child: Icon(Icons.notifications, color: Colors.white, size: 22), // was default
        ),
      ],
      toolbarHeight: 92, // was 100
    );
  }

  BottomNavigationBarItem _buildNavItem(String label, IconData iconData) {
    return BottomNavigationBarItem(
      icon: Icon(iconData, size: 22), // was 24
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
      onTap: (index) {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Asset_list()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      items: [
        _buildNavItem('Assets', Icons.inventory_2_outlined),
        _buildNavItem('History', Icons.history),
        _buildNavItem('Home', Icons.home_filled),
        _buildNavItem('Profile', Icons.person),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 15), // was 16
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 9.0, // was 10
          horizontal: 10.0, // was 12
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(7), // was 8
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(7), // was 8
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    const IconData macbookIcon = Icons.laptop_outlined;
    const IconData psIcon = Icons.gamepad_outlined;
    const IconData ipadIcon = Icons.tablet_mac_outlined;
    const IconData vrIcon = Icons.vrpano_outlined;

    Widget buildRadioIcon(int value, IconData iconData) {
      return Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: _selectedIconGroup,
            onChanged: (val) {
              setState(() => _selectedIconGroup = val);
            },
            activeColor: Colors.white,
            fillColor: MaterialStateProperty.all(Colors.white),
          ),
          Icon(iconData, color: Colors.white, size: 34), // was 40
        ],
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [buildRadioIcon(1, macbookIcon), buildRadioIcon(2, psIcon)],
        ),
        const SizedBox(height: 8), // was 10
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [buildRadioIcon(3, ipadIcon), buildRadioIcon(4, vrIcon)],
        ),
      ],
    );
  }

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
              margin: const EdgeInsets.only(top: 18), // was 20
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28), // was 30
                  topRight: Radius.circular(28), // was 30
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0), // was 20
                  child: Container(
                    padding: const EdgeInsets.all(16.0), // was 20
                    margin: const EdgeInsets.only(top: 24), // was 30
                    decoration: BoxDecoration(
                      color: secondaryDarkBlue,
                      borderRadius: BorderRadius.circular(14), // was 16
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 76, // was 80
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15, // was 16
                                  fontWeight: FontWeight.w600, // was 700
                                ),
                              ),
                            ),
                            const SizedBox(width: 8), // was 10
                            Expanded(child: _buildTextField()),
                          ],
                        ),
                        const SizedBox(height: 14), // was 16
                        Row(
                          children: [
                            const SizedBox(
                              width: 76, // was 80
                              child: Text(
                                'ID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15, // was 16
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTextField()),
                          ],
                        ),
                        const SizedBox(height: 20), // was 24
                        _buildIconSelector(),
                        const SizedBox(height: 20), // was 24
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, color: Colors.black, size: 20),
                            label: const Text(
                              'Add icon',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15, // was 16
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18, // was 20
                                vertical: 10,  // was 12
                              ),
                              minimumSize: const Size(0, 38),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // was 24
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 0, 145, 29),
                                fixedSize: const Size(112, 40), // was 120x44
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15, // was 16
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Asset_list(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 163, 0, 0),
                                fixedSize: const Size(112, 40), // was 120x44
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15, // was 16
                                  fontWeight: FontWeight.w700,
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
