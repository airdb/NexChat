import 'package:flutter/material.dart';

class ChatPopupMenu extends StatelessWidget {
  const ChatPopupMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.copy,
            label: '复制',
            onTap: () {
              // TODO: 实现复制功能
              Navigator.pop(context);
            },
          ),
          _buildActionButton(
            icon: Icons.share,
            label: '转发',
            onTap: () {
              // TODO: 实现转发功能
              Navigator.pop(context);
            },
          ),
          _buildActionButton(
            icon: Icons.bookmark,
            label: '收藏',
            onTap: () {
              // TODO: 实现收藏功能
              Navigator.pop(context);
            },
          ),
          _buildActionButton(
            icon: Icons.delete,
            label: '删除',
            onTap: () {
              // TODO: 实现删除功能
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
} 