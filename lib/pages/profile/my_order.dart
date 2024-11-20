import 'package:flutter/material.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Top icons section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTopIcon(Icons.shopping_cart, 'Cart'),
                _buildTopIcon(Icons.local_offer, 'Coupons'),
                _buildTopIcon(Icons.card_membership, 'Cards'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Stores section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Viewed Stores',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildStoreItem('Fresh Forest', 'assets/store1.png'),
                      _buildStoreItem('Fortune Imports', 'assets/store2.png'),
                      _buildStoreItem('RONGYE Cashmere', 'assets/store3.png'),
                      _buildStoreItem('Sweet Foods', 'assets/store4.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Orders section
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildOrderTabs(),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildOrderItem(
                          storeName: 'Sichuan Kitchen',
                          productName: '[Liu No.5] Sesame Noodles',
                          price: '\$9.90',
                          quantity: 'x1',
                          status: 'Completed',
                        ),
                        _buildOrderItem(
                          storeName: 'Yonghui Spring',
                          productName: 'Shanghai Fresh Milk Soup Dumplings',
                          price: '\$238.00',
                          quantity: 'x1',
                          status: 'To Use',
                          validUntil: 'Please use before 2025/03/31 23:59',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStoreItem(String name, String imageAsset) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(imageAsset),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('All', isSelected: true),
          _buildTab('To Pay'),
          _buildTab('To Ship'),
          _buildTab('To Receive/Use'),
          _buildTab('Refund/After-sale'),
          _buildTab('To Review'),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {bool isSelected = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: isSelected ? Colors.black : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildOrderItem({
    required String storeName,
    required String productName,
    required String price,
    required String quantity,
    required String status,
    String? validUntil,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[200],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName),
                    const SizedBox(height: 4),
                    if (validUntil != null)
                      Text(
                        validUntil,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(price),
                        Text(quantity),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 