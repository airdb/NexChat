import 'package:flutter/material.dart';
import 'chat_popup.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String contactAvatarUrl;
  final String sessionId;

  const ChatScreen({
    Key? key,
    required this.contactName,
    required this.contactAvatarUrl,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final List<ChatMessage> _messages = messages;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          content: _messageController.text,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
    });
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.contactName,
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
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessageWidget(
                  message: message,
                  contactAvatarUrl: widget.contactAvatarUrl,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              // TODO: implement emoji picker
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                fillColor: Colors.grey.shade50,
                filled: true,
              ),
              minLines: 1,
              maxLines: 4,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            color: const Color(0xFF1677ff), // 使用CSS中定义的蓝色
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
              radius: 20,
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: message.isMe ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: SelectableText(
              message.content,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black,
              ),
              onSelectionChanged: (selection, cause) {
                if (selection.baseOffset != selection.extentOffset) {
                  // 文本被选中时的处理
                }
              },
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: AssetImage('assets/avatar/my_avatar.png'),
              radius: 20,
            ),
          ],
        ],
      ),
    );
  }
}

// Sample message data
final List<ChatMessage> messages = [
  ChatMessage(
    content: "Hey, I've been thinking about personal growth lately. Any advice?",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  ChatMessage(
    content: "Actually, I've found that continuous learning and setting clear goals has helped me a lot",
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  ChatMessage(
    content: "That makes sense. What about financial growth? How do you manage that?",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
  ChatMessage(
    content: "I focus on multiple income streams. Besides my main job, I'm learning to invest and doing some freelance work",
    isMe: true, 
    timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
  ChatMessage(
    content: "Interesting! What kind of freelance work do you do?",
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
  ),
  ChatMessage(
    content: "I do mobile app development. The tech industry pays well, and there's always demand. Plus, you can work remotely for clients worldwide.",
    isMe: true,
    timestamp: DateTime.now(),
  )
];