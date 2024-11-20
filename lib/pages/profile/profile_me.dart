import 'package:flutter/material.dart';

class ProfileMePage extends StatelessWidget {
  const ProfileMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildProfileItem(
            title: '头像',
            trailing: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: const DecorationImage(
                  image: AssetImage('assets/default_avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _buildProfileItem(
            title: '名字',
            trailing: const Text('阿正_Dean ≧ᴗ≦'),
          ),
          _buildProfileItem(
            title: '拍一拍',
            trailing: const Text('得到了正能量😊'),
          ),
          _buildProfileItem(
            title: '微信号',
            trailing: const Text('bumu'),
          ),
          _buildProfileItem(
            title: '我的二维码',
            trailing: const Icon(Icons.qr_code_2),
          ),
          _buildProfileItem(title: '更多'),
          const SizedBox(height: 8),
          _buildProfileItem(title: '我的地址'),
          _buildProfileItem(title: '微信豆'),
          _buildProfileItem(title: '我的发票抬头'),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required String title,
    Widget? trailing,
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
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () {},
      ),
    );
  }
} 