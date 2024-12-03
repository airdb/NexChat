import 'package:flutter/material.dart';
import 'add_card.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEE4D2D),
        title: const Text(
          'WePay',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: Implement settings action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top section with Insurance, Digital Products, Finance
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                  },
                  child: _buildMenuItem(Icons.people, 'Relative Cards'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCardPage()),
                    );
                  },
                  child: _buildMenuItem(Icons.credit_card, 'Bank Cards'),
                ),
              ],
            ),
          ),
          
          // Promotion Banner
          /*
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/promotion_banner.png', // 需要添加对应的资源图片
                fit: BoxFit.cover,
              ),
            ),
          ),
          */

          // Last Transactions Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Last Transactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement view more action
                  },
                  child: const Text('View More >'),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView(
              children: [
                _buildTransactionItem(
                  date: '22 March 2024',
                  merchant: 'Airdb Tech Private Limited',
                  amount: -0.70,
                ),
                _buildTransactionItem(
                  date: '06 March 2024',
                  merchant: 'Airdb Tech Private Limited',
                  amount: -0.70,
                ),
                _buildTransactionItem(
                  date: '06 February 2024',
                  merchant: 'Airdb Tech Private Limited',
                  amount: -0.70,
                ),
                _buildTransactionItem(
                  date: '26 January 2024',
                  merchant: 'Airdb Tech Private Limited',
                  amount: -0.80,
                ),
                _buildTransactionItem(
                  date: '24 January 2024',
                  merchant: 'Sarawak Kolo Mee @ FP',
                  amount: -6.80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String date,
    required String merchant,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.receipt_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  merchant,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 