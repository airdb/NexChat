import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String contactName;
  final String contactAvatarUrl;

  const ChatScreen({
    Key? key,
    required this.contactName,
    required this.contactAvatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          contactName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatMessageWidget(
                  message: message,
                  contactAvatarUrl: contactAvatarUrl,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '发送消息...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // TODO: 实现发送消息功能
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isMe,
    required this.timestamp,
  });
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final String contactAvatarUrl;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.contactAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(contactAvatarUrl),
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: message.isMe ? Colors.green[300] : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: NetworkImage('您的头像URL'), // TODO: 替换为实际的用户头像
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }
}

// 示例消息数据
final List<ChatMessage> messages = [
  ChatMessage(
    content: '你好',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  ChatMessage(
    content: '你好啊！',
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  ChatMessage(
    content: '最近在忙什么呢？',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
  ChatMessage(
    content: '在写一个Flutter项目，你呢？',
    isMe: true, 
    timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
  ChatMessage(
    content: '我也在学Flutter！有什么好的学习资源推荐吗？',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
  ),
  ChatMessage(
    content: '官方文档写得很详细，我觉得是最好的入门资料。另外B站上也有很多优质教程。',
    isMe: true,
    timestamp: DateTime.now(),
  )
]; 