import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_mini_program.dart'; // Import the new page

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
    // 添加滚动监听
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 处理滚动事件
  void _onScroll() {
    // 检测是否滚动到底部
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('Scroll to bottom');
      _loadMore();
    }
    
    // 检测是否滚动到顶部
    if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      print('Scroll to top');
      _refreshTop();
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      
      // 在这里添加加载更多数据的逻辑
      print('Loading more data...');
      await Future.delayed(Duration(seconds: 2)); // 模拟网络请求
      
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _refreshTop() async {
    print('Debug: Refreshing from top... jump to mini program page');
    Navigator.pushNamed(
      context,
      '/chat/mini_program', // 修改为小程序页面的路由
      );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshTop,
      child: Material(
        child: ListView.separated(
          controller: _scrollController, // 添加控制器
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