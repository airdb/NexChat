import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Search bar
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.contactSearch,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            // Contact list
            Expanded(
              child: ListView(
                children: [
                  ContactListItem(
                    icon: Icons.person_add_outlined,
                    color: Colors.orange,
                    title: l10n.contactNewFriends,
                  ),
                  ContactListItem(
                    icon: Icons.group_outlined,
                    color: Colors.orange,
                    title: l10n.contactGroupChats,
                  ),
                  ContactListItem(
                    icon: Icons.star_outline,
                    color: Colors.blue,
                    title: l10n.contactTags,
                  ),
                  ContactListItem(
                    icon: Icons.campaign_outlined,
                    color: Colors.blue,
                    title: l10n.contactOfficialAccounts,
                  ),
                  ContactListItem(
                    icon: Icons.account_balance_outlined,
                    color: Colors.blue,
                    title: l10n.contactGovernmentAccount,
                  ),
                  ContactListItem(
                    icon: Icons.business_center_outlined,
                    color: Colors.blue,
                    title: l10n.contactBusinessContacts,
                  ),
                  GroupTitle(title: l10n.contactCompanyOrShop),
                  ContactListItem(
                    icon: Icons.apartment_outlined,
                    color: Colors.lightBlue,
                    title: l10n.contactCompany,
                  ),
                  ContactListItem(
                    icon: Icons.shopping_bag_outlined,
                    color: Colors.purple,
                    title: l10n.contactShop,
                  ),
                  ContactListItem(
                    icon: Icons.store_outlined,
                    color: Colors.red,
                    title: l10n.contactStore,
                  ),
                  ContactListItem(
                    icon: Icons.shopping_cart_outlined,
                    color: Colors.red,
                    title: l10n.contactMerchant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactListItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;

  const ContactListItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      minLeadingWidth: 40,
    );
  }
}

class GroupTitle extends StatelessWidget {
  final String title;

  const GroupTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
} 