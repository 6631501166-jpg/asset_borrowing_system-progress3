import 'package:flutter/material.dart';
import 'package:asset_borrowing_system/services/api_service.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool notificationsEnabled = false;
  bool _isLoading = true;
  String? _error;

  Map<String, dynamic> _appInfo = {};
  Map<String, dynamic> _supportInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      final Map<String, dynamic> settings = await ApiService.fetchSettings();
      setState(() {
        notificationsEnabled = settings['notifications_enabled'] ?? false;
        _appInfo = settings['app_info'] ?? {};
        _supportInfo = settings['support_info'] ?? {};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load settings: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateNotifications(bool value) async {
    setState(() {
      notificationsEnabled = value;
    });
    try {
      await ApiService.updateSettings({'notifications_enabled': value});
    } catch (e) {
      setState(() {
        notificationsEnabled = !value; // Revert on error
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update notifications: $e')));
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final result = await ApiService.deleteAccount();
      if (result['success']) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete account: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C1851),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1851),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Setting', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF081038),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: notificationsEnabled,
                      onChanged: _updateNotifications,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.5),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(
                        0xFF0C1851,
                      ).withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingButton('Delete Account', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                      'Are you sure you want to delete your account?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteAccount();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
            const SizedBox(height: 16),
            _buildSettingButton('Contact Support', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Contact Support'),
                    content: Text(
                      'Email: ${_supportInfo['email'] ?? 'support@example.com'}\nPhone: ${_supportInfo['phone'] ?? '+66 012 345 6789'}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }),
            const SizedBox(height: 16),
            _buildSettingButton('About app', () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About App'),
                    content: Text(
                      'App Name: ${_appInfo['name'] ?? 'My App'}\nVersion: ${_appInfo['version'] ?? '1.0.1'}\nDeveloper: ${_appInfo['developer'] ?? 'Your Company'}\n\nThank you for using our app!',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }),
            const Spacer(),
            Text(
              'Version ${_appInfo['version'] ?? '1.0.1'}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF081038),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
