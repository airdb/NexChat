import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _chatItems.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0.5,
        color: Colors.black12,
      ),
      itemBuilder: (context, index) {
        final chat = _chatItems[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              chat.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          subtitle: Text(
            chat.message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          trailing: Text(
            chat.time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}

class ChatItemData {
  final String name;
  final String message;
  final String time;

  ChatItemData({
    required this.name,
    required this.message,
    required this.time,
  });
}

final List<ChatItemData> _chatItems = [
  ChatItemData(
    name: "Alex Johnson",
    message: "Want to grab coffee later?",
    time: "09:23",
  ),
  ChatItemData(
    name: "Emma Wilson",
    message: "How's the project going?",
    time: "08:45",
  ),
  ChatItemData(
    name: "Michael Brown",
    message: "Meeting at 2pm today",
    time: "Yesterday",
  ),
  ChatItemData(
    name: "Sarah Davis",
    message: "I sent you the files",
    time: "11:05",
  ),
  ChatItemData(
    name: "James Smith",
    message: "Thanks for your help!",
    time: "10:17",
  ),
  ChatItemData(
    name: "Emily Taylor",
    message: "See you at lunch",
    time: "Wed",
  ),
  ChatItemData(
    name: "David Miller",
    message: "Don't forget the meeting",
    time: "Tue",
  ),
  ChatItemData(
    name: "Sophie Clark",
    message: "Are you free tomorrow?",
    time: "Mon",
  ),
  ChatItemData(
    name: "Oliver White",
    message: "Check the latest updates",
    time: "Sun",
  ),
]; 