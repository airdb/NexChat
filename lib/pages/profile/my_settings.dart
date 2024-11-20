import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            'General',
            [
              ListTile(
                title: const Text('Language'),
                trailing: const Text('English'),
                onTap: () {
                  // Handle language selection
                },
              ),
              ListTile(
                title: const Text('Font Size'),
                trailing: const Text('Medium'),
                onTap: () {
                  // Handle font size selection
                },
              ),
            ],
          ),
          _buildSection(
            'Privacy',
            [
              ListTile(
                title: const Text('Chat History'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to chat history settings
                },
              ),
              ListTile(
                title: const Text('Blocked Users'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to blocked users
                },
              ),
            ],
          ),
          _buildSection(
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Message Notifications'),
                value: true,
                onChanged: (bool value) {
                  // Handle message notifications toggle
                },
              ),
              SwitchListTile(
                title: const Text('Group Notifications'),
                value: true,
                onChanged: (bool value) {
                  // Handle group notifications toggle
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
} 