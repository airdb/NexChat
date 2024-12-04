import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../system/permission.dart';

class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('设备管理'),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            icon: Icons.print,
            iconColor: Colors.purple,
            title: "Printer",
            subtitle: "Manage printer devices",
            onTap: () async {
              bool hasPermission = await PermissionUtil.requestBluetoothPermissions(context);
              hasPermission = true;
              if (hasPermission) {
                Navigator.pushNamed(context, '/profile/printer');
              }
            },
          ),
          _buildMenuItem(
            icon: Icons.nfc,
            iconColor: Colors.blue,
            title: "NFC Device",
            subtitle: "Manage NFC devices",
            onTap: () {
              Navigator.pushNamed(context, '/profile/nfc');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
} 