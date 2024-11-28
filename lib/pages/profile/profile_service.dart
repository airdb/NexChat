import 'package:flutter/material.dart';


class ProfileServicePage extends StatelessWidget {
  const ProfileServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top green area
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green,
              child: Row(
                children: [
                  Expanded(
                    child: _buildTopItem(Icons.arrow_outward, 'Payment'),
                  ),
                  Expanded(
                    child: _buildTopItem(Icons.account_balance_wallet, 'Wallet\n\$5,001,008.93'),
                  ),
                ],
              ),
            ),
            
            // Financial Services
            _buildSection(
              'Financial Services',
              [
                _buildServiceItem(Icons.credit_card, 'Credit Card Payment', Colors.green),
                _buildServiceItem(Icons.account_balance, 'Quick Loan', Colors.orange),
                _buildServiceItem(Icons.access_time, 'Wealth Management', Colors.blue),
                _buildServiceItem(Icons.security, 'Insurance Services', Colors.orange),
              ],
            ),
            
            // Life Services
            _buildSection(
              'Life Services',
              [
                _buildServiceItem(Icons.phone_android, 'Mobile Top-up', Colors.blue),
                _buildServiceItem(Icons.local_offer, 'Utilities Payment', Colors.green),
                _buildServiceItem(Icons.qr_code, 'Q Coins Top-up', Colors.blue),
                _buildServiceItem(Icons.location_city, 'City Services', Colors.green),
                _buildServiceItem(Icons.favorite, 'Tencent Charity', Colors.red),
                _buildServiceItem(Icons.local_hospital, 'Healthcare', Colors.orange),
              ],
            ),

            // Transportation
            _buildSection(
              'Transportation',
              [
                _buildServiceItem(Icons.flight, 'Travel Services', Colors.blue),
                _buildServiceItem(Icons.train, 'Train Tickets', Colors.green),
                _buildServiceItem(Icons.directions_car, 'Grab Ride', Colors.orange),
                _buildServiceItem(Icons.hotel, 'Hotels & Tourism', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItem(IconData icon, String text) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          if (text == 'Payment') {
            Navigator.pushNamed(context, '/profile/payment_code');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: items,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 