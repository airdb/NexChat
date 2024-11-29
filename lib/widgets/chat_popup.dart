import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';

class ChatPopupMenu extends StatelessWidget {
  final String? content;
  final Function()? onDelete;
  final Function()? onFavorite;

  const ChatPopupMenu({
    super.key,
    this.content,
    this.onDelete,
    this.onFavorite,
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
              if (content != null) {
                Clipboard.setData(ClipboardData(text: content!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制到剪贴板')),
                );
              }
              Navigator.pop(context);
            },
          ),
          _buildActionButton(
            icon: Icons.share,
            label: '转发',
            onTap: () async {
              if (content != null) {
                await FlutterShare.share(
                  title: '分享对话',
                  text: content!,
                );
              }
              Navigator.pop(context);
            },
          ),
          _buildActionButton(
            icon: Icons.bookmark,
            label: '收藏',
            onTap: () {
              if (onFavorite != null) {
                onFavorite!();
              }
              Navigator.pop(context);
            },
          ),
          _buildActionButton(
            icon: Icons.delete,
            label: '删除',
            onTap: () {
              if (onDelete != null) {
                onDelete!();
              }
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