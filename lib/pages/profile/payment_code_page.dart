import 'package:flutter/material.dart';

class PaymentCodePage extends StatelessWidget {
  const PaymentCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Payment code area
          Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'This feature is used to show payment to merchants. Please do not send the payment code or numbers to others.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Got it'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Other payment options
          ListTile(
            leading: const Icon(Icons.currency_yuan, color: Colors.red),
            title: const Text('Digital RMB Payment'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code, color: Colors.green),
            title: const Text('QR Code Payment'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.attach_money, color: Colors.green),
            title: const Text('Tip Code'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.group, color: Colors.green),
            title: const Text('Group Payment'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
} 