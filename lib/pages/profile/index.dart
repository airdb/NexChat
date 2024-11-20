import 'package:flutter/material.dart';
import 'package:nexchat/pages/profile/profile_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: InkWell(
              onTap: () {
                print("Debug: Profile header tapped");
                Navigator.pushNamed(context, '/profile/me');
              },
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: const DecorationImage(
                        image: AssetImage('assets/default_avatar.png'),
                        // 替换为实际的头像图片
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dean SA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NexChat ID: bumu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Menu Items
          _buildMenuItem(
            icon: Icons.support_agent,
            iconColor: Colors.green,
            title: "Services",
            onTap: () {
              Navigator.pushNamed(context, '/profile/service');
            },
          ),
          _buildMenuItem(
            icon: Icons.collections_bookmark,
            iconColor: Colors.orange,
            title: "Favorites",
          ),
          _buildMenuItem(
            icon: Icons.photo_library,
            iconColor: Colors.blue,
            title: "Moments",
          ),
          _buildMenuItem(
            icon: Icons.card_giftcard,
            iconColor: Colors.red,
            title: "Cards & Offers",
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag,
            iconColor: Colors.deepOrange,
            title: "Orders",
          ),
          _buildMenuItem(
            icon: Icons.emoji_emotions,
            iconColor: Colors.amber,
            title: "Sticker Gallery",
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.settings,
            iconColor: Colors.grey,
            title: "Settings",
            onTap: () {
              Navigator.pushNamed(context, '/profile/settings');
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