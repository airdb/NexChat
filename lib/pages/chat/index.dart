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
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 设置透明背景
        elevation: 0, // 移除阴影
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add_circle_outline),
              onSelected: (value) {
                switch (value) {
                  case 0:
                    print(localizations.chatStartGroupChat);
                    break;
                  case 1:
                    print(localizations.chatAddFriend);
                    break;
                  case 2:
                    print(localizations.chatScanQr);
                    break;
                  case 3:
                    print(localizations.chatPayment);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    leading: const Icon(Icons.chat),
                    title: Text(localizations.chatStartGroupChat),
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: const Icon(Icons.person_add),
                    title: Text(localizations.chatAddFriend),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: const Icon(Icons.qr_code_scanner),
                    title: Text(localizations.chatScanQr),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: const Icon(Icons.payment),
                    title: Text(localizations.chatPayment),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
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
              print('Avatar URL for ${chat.name}: ${chat.avatarUrl}');

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
                    /*
                    child: SvgPicture.network(
                      chat.avatarUrl,
                      fit: BoxFit.cover,
                      // 加载时显示进度条
                      placeholderBuilder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      // 发生错误时显示默认头像图标
                      onError: (error, stackTrace) {
                        print('Error loading SVG avatar: $error');
                        return const Icon(Icons.person, color: Colors.white);
                      },
                    ),
                    ),
                    */
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