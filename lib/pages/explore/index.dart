import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  l10n.tabExploreTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        // List items
        Expanded(
          child: Container(
            color: Colors.grey[50],
            child: ListView(
              children: [
                _buildExploreItem(
                  icon: Icons.restaurant_outlined,
                  iconColor: const Color(0xFFFF6B6B),
                  title: l10n.exploreFoodDining,
                ),
                const Divider(height: 1, indent: 56),
                _buildExploreItem(
                  icon: Icons.coffee_outlined,
                  iconColor: const Color(0xFF795548),
                  title: l10n.exploreDrinksCafes,
                ),
                const Divider(height: 1, indent: 56),
                _buildExploreItem(
                  icon: Icons.celebration_outlined,
                  iconColor: const Color(0xFFE91E63),
                  title: l10n.exploreEntertainment,
                ),
                const Divider(height: 1, indent: 56),
                _buildExploreItem(
                  icon: Icons.flight_outlined,
                  iconColor: const Color(0xFF2196F3),
                  title: l10n.exploreTravel,
                ),
                const Divider(height: 1, indent: 56),
                _buildExploreItem(
                  icon: Icons.shopping_bag_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  title: l10n.exploreShopping,
                ),
                const Divider(height: 1, indent: 56),
                _buildExploreItem(
                  icon: Icons.groups_outlined,
                  iconColor: const Color(0xFF9C27B0),
                  title: l10n.exploreMeetup,
                ),
                _buildExploreItem(
                  icon: Icons.work_outline,
                  iconColor: const Color(0xFF607D8B),
                  title: l10n.exploreJobs,
                ),
                Container(
                  height: 8,
                  color: Colors.grey[200],
                ),
                _buildExploreItem(
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFFFF9800),
                  title: l10n.exploreToday,
                ),
                const Divider(height: 1, indent: 56),
                _buildExploreItem(
                  icon: Icons.location_on_outlined,
                  iconColor: const Color(0xFF1878F3),
                  title: l10n.exploreNearby,
                ),
                Container(
                  height: 8,
                  color: Colors.grey[200],
                ),
                _buildExploreItem(
                  icon: Icons.apps_outlined,
                  iconColor: const Color(0xFF8B44FF),
                  title: l10n.exploreMiniProgram,
                  onTap: () {
                    Navigator.pushNamed(context, '/explore/mini-program');
                  },
                ),
                const Divider(height: 1, indent: 56),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExploreItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
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
      ),
    );
  }
} 