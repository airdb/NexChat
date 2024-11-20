import 'package:flutter/material.dart';

class MiniProgramPage extends StatelessWidget {
  const MiniProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Programs'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Recently Used',
            items: [
              _buildMiniProgramItem(
                icon: 'assets/icons/jj.png',
                label: 'JJ Home',
                backgroundColor: const Color(0xFFF4E1D3),
              ),
              _buildMiniProgramItem(
                icon: 'assets/icons/cloud.png',
                label: 'Cloud Assistant',
                backgroundColor: const Color(0xFFE6F0FF),
              ),
              _buildMiniProgramItem(
                icon: 'assets/icons/house.png',
                label: 'Small House Rental',
                backgroundColor: const Color(0xFFFFE6E6),
              ),
            ],
          ),
          _buildSection(
            title: 'My Mini Programs',
            items: [
              _buildMiniProgramItem(
                icon: 'assets/icons/jj.png',
                label: 'JJ Home',
                backgroundColor: const Color(0xFFF4E1D3),
              ),
              _buildMiniProgramItem(
                icon: 'assets/icons/house.png',
                label: 'Small House Rental',
                backgroundColor: const Color(0xFFFFE6E6),
              ),
              _buildMiniProgramItem(
                icon: 'assets/icons/knowledge.png',
                label: 'Knowledge',
                backgroundColor: const Color(0xFFE6E6FF),
              ),
              _buildMiniProgramItem(
                icon: 'assets/icons/grab.png',
                label: 'Grab',
                backgroundColor: const Color(0xFFE6FFE6),
              ),
            ],
          ),
          _buildSection(
            title: 'Featured Services',
            items: [
              _buildServiceItem(
                icon: 'assets/icons/grab.png',
                title: 'Grab Overseas Car',
                subtitle: 'Providing safe and reliable transportation services for all users',
                backgroundColor: const Color(0xFFE6FFE6),
              ),
              _buildServiceItem(
                icon: 'assets/icons/rws.png',
                title: 'RWS Global',
                subtitle: 'Can check real-time official website prices',
                backgroundColor: const Color(0xFFFFE6E6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              if (title != 'Featured Services')
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
            ],
          ),
        ),
        if (title != 'Featured Services')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: items,
            ),
          )
        else
          Column(children: items),
      ],
    );
  }

  Widget _buildMiniProgramItem({
    required String icon,
    required String label,
    required Color backgroundColor,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(icon),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildServiceItem({
    required String icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }
} 