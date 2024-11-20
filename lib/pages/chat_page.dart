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
    name: "微信大河南",
    message: "dwdf",
    time: "08:00",
  ),
  ChatItemData(
    name: "哈哈哈",
    message: "几开",
    time: "08:00",
  ),
  ChatItemData(
    name: "myname",
    message: "yy",
    time: "08:00",
  ),
  ChatItemData(
    name: "哈哈哈",
    message: "IE8落金辉",
    time: "08:00",
  ),
  ChatItemData(
    name: "w发发发",
    message: "合家欢",
    time: "08:00",
  ),
  ChatItemData(
    name: "1222User155",
    message: "effeefg",
    time: "08:00",
  ),
  ChatItemData(
    name: "159",
    message: "2323",
    time: "08:00",
  ),
  ChatItemData(
    name: "125",
    message: "2323",
    time: "08:00",
  ),
  ChatItemData(
    name: "10001",
    message: "12323",
    time: "08:00",
  ),
]; 