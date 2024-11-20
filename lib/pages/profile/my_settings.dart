import 'package:flutter/material.dart';

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey[50],
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSettingsGroup([
              _buildSettingsItem(title: 'Account & Security', onTap: () {}),
              _buildSettingsItem(title: 'Teen Mode', onTap: () {}),
              _buildSettingsItem(title: 'Friend Mode', onTap: () {}),
            ]),
            _buildSettingsGroup([
              _buildSettingsItem(title: 'Message Notifications', onTap: () {}),
              _buildSettingsItem(title: 'General', onTap: () {}),
            ]),
            _buildSettingsGroup([
              _buildSettingsItem(title: 'Privacy', onTap: () {}),
              _buildSettingsItem(title: 'Friend Permissions', onTap: () {}),
              _buildSettingsItem(title: 'Data Management', onTap: () {}),
              _buildSettingsItem(title: 'Third-party App Data', onTap: () {}),
            ]),
            _buildSettingsGroup([
              _buildSettingsItem(title: 'Help & Feedback', onTap: () {}),
              _buildSettingsItem(title: 'About', onTap: () {}),
            ]),
            _buildSettingsGroup([
              _buildSettingsItem(
                title: 'Switch Account',
                showArrow: false,
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: showArrow
              ? Icon(Icons.chevron_right, color: Colors.grey[400], size: 20)
              : null,
        ),
      ),
    );
  }
} 