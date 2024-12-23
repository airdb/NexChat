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
            'General',
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
                title: const Text('Friends Privacy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to chat history settings
                },
              ),
              ListTile(
                title: const Text('Personal Privacy List'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to blocked users
                },
              ),
              ListTile(
                title: const Text('Third Party Privacy Sharing'),
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
          _buildSection(
            'About',
            [
              ListTile(
                title: const Text('Feedback'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to feedback
                },
              ),
              ListTile(
                title: const Text('About'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Version1.0.0"),
                    Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  // Navigate to about
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text(
              'Switch Account',
              textAlign: TextAlign.center,
            ),            
            onTap: () {
              // TODO: switch account
            },
          ),
          ListTile(
            title: const Text(
              'Logout',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              // TODO: logout
            },
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
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
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