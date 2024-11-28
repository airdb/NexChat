import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'index.dart';

class ChatMiniProgramPage extends StatelessWidget {
  const ChatMiniProgramPage({super.key});

  static const double _gridPadding = 16.0;
  static const int _crossAxisCount = 4;
  static const double _avatarRadius = 28.0;
  static const int _itemCount = 8;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.miniProgramRecent),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          _buildSectionHeader(context, 'Recently Used Mini Programs'),
          _buildGridView(),
          _buildSectionHeader(context, 'My Mini Programs'),
          _buildGridView(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.chat),
              Text(
                localizations.appTitle, 
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'More >',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(_gridPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          mainAxisSpacing: _gridPadding,
          crossAxisSpacing: _gridPadding,
        ),
        itemCount: _itemCount,
        itemBuilder: (context, index) => _MiniProgramItem(
          name: 'mini-${index + 1}',
          index: index,
        ),
      ),
    );
  }
}

class _MiniProgramItem extends StatelessWidget {
  const _MiniProgramItem({
    required this.name,
    required this.index,
  });

  final String name;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: ChatMiniProgramPage._avatarRadius,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.apps, size: 28, color: Colors.blue),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 12, color: Colors.white),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
} 