import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_mini_program.dart'; // Import the new page
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localization file

export 'chat_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Handle scroll events
  void _onScroll() {
    // Check if scrolled to bottom
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('Scroll to bottom');
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      
      // Add logic for loading more data here
      print('Loading more data...');
      await Future.delayed(Duration(seconds: 2)); // Simulate network request
      
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _refreshTop() async {
    print('Debug: Refreshing from top...');
    if (!mounted) return;
    
    Navigator.of(context).push(
      PageRouteBuilder(
        // 减少动画时间使其更快速
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => const ChatMiniProgramPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 添加一个缩放效果
          final scaleAnimation = Tween<double>(
            begin: 0.88,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            // 使用 easeOutQuart 曲线使动画更自然
            curve: Curves.easeOutQuart,
          ));

          // 结合滑动和缩放效果
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            )),
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Column(
        children: [
          // 新增的标题和搜索框部分
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ask Ollama AI or Search',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 原有的聊天列表部分
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTop,
              child: Material(
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: _chatItems.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 0.5,
                    color: Colors.black12,
                  ),
                  itemBuilder: (context, index) {
                    final chat = _chatItems[index];
                    return Material(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              chat.avatarUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading avatar: $error');
                                return const Icon(Icons.person, color: Colors.white);
                              },
                            ),
                          ),
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
                        onTap: () {
                          final args = {
                            'contactName': chat.name,
                            'contactAvatarUrl': chat.avatarUrl,
                            'sessionId': chat.sessionId,
                          };
                          print('Debug: Sending arguments from ChatPage: $args');
                          Navigator.pushNamed(
                            context,
                            '/chat/detail',
                            arguments: args,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItemData {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final String sessionId;

  ChatItemData({
    required this.name,
    required this.message,
    required this.time,
    String? sessionId,
  }) : avatarUrl = generateAvatarUrl(name),
       sessionId = sessionId ?? name.toLowerCase().replaceAll(' ', '_');

  static String generateAvatarUrl(String name) {
    /*
    final randomNumber = (name.hashCode % 5) + 1;
    return 'assets/avatar/avatar_0${randomNumber}.png';
    */
    // Use name hash to generate a consistent avatar for each name
    final hash = name.hashCode.abs().toString();
    return 'https://api.dicebear.com/7.x/avataaars/png?seed=$hash';
  }
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