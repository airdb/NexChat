import 'package:flutter/material.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  Widget _buildListTile({
    required String title,
    required String? trailing,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          if (showArrow)
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Security'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildListTile(
            title: 'NexChat ID',
            trailing: 'bumu',
          ),
          _buildListTile(
            title: 'Phone Number',
            trailing: '89****76',
          ),
          _buildListTile(
            title: 'NexChat Password',
            trailing: 'Set',
          ),
          _buildListTile(
            title: 'Voice Lock',
            trailing: 'Not Set',
          ),
          _buildListTile(
            title: 'Emergency Contacts',
            trailing: 'Add',
          ),
          _buildListTile(
            title: 'Login Device Management',
            trailing: 'Manage',
          ),
          _buildListTile(
            title: 'More Security Settings',
            trailing: 'Manage',
          ),
          _buildListTile(
            title: 'Help Friend Verify Account',
            trailing: 'Manage',
            ),
          _buildListTile(
            title: 'NexChat Security Center',
            trailing: 'Manage',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'If you encounter account security issues such as password leaks, theft, or fraud, please visit the NexChat Security Center',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 