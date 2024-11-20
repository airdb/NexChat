import 'package:flutter/material.dart';
import '../pages/chat/index.dart';
import '../pages/contact/index.dart';
import '../pages/explore/index.dart';
import '../pages/profile/index.dart';
import '../pages/profile/profile_service.dart';


final Map<String, WidgetBuilder> routes = {
  '/chat': (context) => const ChatPage(),
  '/contacts': (context) => const ContactPage(),
  '/explore': (context) => const ExplorePage(),
  '/profile': (context) => const ProfilePage(),
  '/profile/service': (context) => const ProfileServicePage(),
}; 