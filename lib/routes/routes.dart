import 'package:flutter/material.dart';
import '../pages/chat/index.dart';
import '../pages/contact/index.dart';
import '../pages/explore/index.dart';
import '../pages/profile/index.dart';
import '../pages/profile/profile_service.dart';
import '../pages/chat/chat_screen.dart';
import '../pages/profile/profile_me.dart';
import '../pages/profile/profile_settings.dart';
class Routes {
  static final Map<String, WidgetBuilder> routes = {
    '/chat': (context) => const ChatPage(),
    '/contacts': (context) => const ContactPage(),
    '/explore': (context) => const ExplorePage(),
    '/profile': (context) => const ProfilePage(),
    '/profile/service': (context) => const ProfileServicePage(),
    '/profile/me': (context) => const ProfileMePage(),
    '/profile/settings': (context) => const SettingsPage(),
    '/chat/detail': (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      print('Debug: Arguments received in route builder: $args');
      return ChatScreen(
        contactName: args['contactName'] as String,
        contactAvatarUrl: args['contactAvatarUrl'] as String,
        sessionId: args['sessionId'] as String,
      );
    },
  };
} 