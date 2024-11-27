import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexchat/services/app_icon_service.dart';

class AppIconSettingsPage extends StatefulWidget {
  const AppIconSettingsPage({super.key});

  @override
  State<AppIconSettingsPage> createState() => _AppIconSettingsPageState();
}

class _AppIconSettingsPageState extends State<AppIconSettingsPage> {
  String selectedIcon = 'Rainbow'; // Default selected icon

  final List<Map<String, dynamic>> appIcons = [
    {'name': 'Default', 'icon': 'assets/app_icons/default.png'},
    {'name': 'White', 'icon': 'assets/app_icons/white.png'},
    {'name': 'Rainbow', 'icon': 'assets/app_icons/rainbow.png'},
    {'name': 'Rainbow Black', 'icon': 'assets/app_icons/rainbow_black.png'},
    {'name': 'Rainbow White', 'icon': 'assets/app_icons/rainbow_white.png'},
    {'name': 'Midnight Matte', 'icon': 'assets/app_icons/midnight_matte.png'},
    {'name': 'Midnight Fantasy', 'icon': 'assets/app_icons/midnight_fantasy.png'},
    {'name': 'Karaoke Fantasy', 'icon': 'assets/app_icons/karaoke_fantasy.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Icon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: appIcons.length,
        itemBuilder: (context, index) {
          final icon = appIcons[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: selectedIcon == icon['name']
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Image.asset(
                    icon['icon'],
                    width: 60,
                    height: 60,
                  ),
                ),
                title: Text(
                  icon['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: selectedIcon == icon['name']
                    ? Icon(Icons.check_circle, 
                        color: Theme.of(context).primaryColor)
                    : null,
                onTap: () async {
                  try {
                    // 显示加载指示器
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    
                    // 更改图标
                    await AppIconService.changeAppIcon(icon['name']);
                    
                    // 更新状态
                    setState(() {
                      selectedIcon = icon['name'];
                    });
                    
                    // 关闭加载指示器
                    Navigator.pop(context);
                    
                    // 显示成功消息
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('App icon changed to ${icon['name']}')),
                    );
                  } catch (e) {
                    // 关闭加载指示器
                    Navigator.pop(context);
                    
                    // 显示错误消息
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to change app icon: $e')),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}