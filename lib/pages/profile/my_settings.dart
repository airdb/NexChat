import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings_app_icon.dart';


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
            'App Icon',
            [
              ListTile(
                title: Text('App Icon'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppIconSettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            'General',
            [
              ListTile(
                title: Text(AppLocalizations.of(context)!.appLanguage),
                trailing: Consumer<LocaleProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      provider.locale.languageCode == 'en' 
                        ? 'English' 
                        : '中文'
                    );
                  },
                ),
                onTap: () => _showLanguageDialog(context),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.tabProfileSettingsFontSizeName),
                trailing: Text(AppLocalizations.of(context)!.tabProfileSettingsFontSizeMedium),
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

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.appLanguage),
          content: Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('English'),
                    trailing: provider.locale.languageCode == 'en'
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      provider.setLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('中文'),
                    trailing: provider.locale.languageCode == 'zh'
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      provider.setLocale(const Locale('zh'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
} 