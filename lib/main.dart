import 'package:flutter/material.dart';
import 'pages/chat/index.dart';
import 'pages/chat/chat_screen.dart';
import 'pages/contact/index.dart';
import 'pages/explore/index.dart';
import 'pages/profile/index.dart';
import 'pages/profile/my_settings.dart';
import 'routes/routes.dart';
import 'pages/profile/my_order.dart';
import 'pages/profile/my_account.dart';
import 'pages/explore/mini_program.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/locale_provider.dart';
import 'pages/chatbot/index.dart';
import 'pages/profile/payment_code_page.dart';
import 'pages/chat/chat_mini_program.dart';
import 'pages/chat/qr_scan_page.dart';
import 'system/device_info.dart';
import 'services/heartbeat.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexChat',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        print("Debug - Route Settings: ${settings.name}, Args: ${settings.arguments}");
        
        // Check if it's a chat/detail route
        if (settings.name == '/chat/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              sessionId: args['sessionId'] as String,
              contactName: args['contactName'] as String,
              contactAvatarUrl: args['contactAvatarUrl'] as String,
            ),
          );
        }
        
        // Check if it's a profile/settings route
        if (settings.name == '/profile/settings') {
          return MaterialPageRoute(
            builder: (context) => const MySettingsPage(),
          );
        }

        // Check if it's a profile/account route
        if (settings.name == '/profile/account') {
          return MaterialPageRoute(
            builder: (context) => const MyAccountPage(),
          );
        }

        // Check if it's an explore/mini-program route
        if (settings.name == '/explore/mini-program') {
          return MaterialPageRoute(
            builder: (context) => const MiniProgramPage(),
          );
        }

        // Check if it's a chatbot route
        if (settings.name == '/chatbot') {
          return MaterialPageRoute(
            builder: (context) => const ChatbotPage(),
          );
        }
        
        // Check if the route exists in predefined routes
        final route = Routes.routes[settings.name];
        if (route != null) {
          return MaterialPageRoute(
            builder: route,
          );
        }
        
        return null;
      },
      home: const MyHomePage(title: 'NexChat'),
      routes: {
        '/chat/index': (context) => const ChatPage(),
        '/profile/order': (context) => const MyOrderPage(),
        '/profile/payment_code': (context) => const PaymentCodePage(),
        '/chat/mini_program': (context) => const ChatMiniProgramPage(),
        '/chat/qr_scan_page': (context) => const QRScanPage(),
      },
      locale: Provider.of<LocaleProvider>(context).locale,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, String> deviceInfo;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceLocale = Localizations.localeOf(context);
      print('current device locale: ${deviceLocale.languageCode}-${deviceLocale.countryCode}');

      HeartbeatService().startHeartbeat(context);
    });
  }

  String _getTitle(AppLocalizations localizations) {
    switch (_selectedIndex) {
      case 0:
        return localizations.appTitle;
      case 1:
        return localizations.tabContactsTitle;
      case 2:
        return localizations.tabChatbotTitle;
      case 3:
        return localizations.tabExploreTitle;
      case 4:
        return localizations.tabProfileTitle;
      default:
        return localizations.appTitle;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ChatPage(),
    const ContactPage(),
    const ChatbotPage(),
    const ExplorePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: _buildAppBar(context, localizations),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: localizations.tabChatTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contacts),
            label: localizations.tabContactsTitle,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/chat_64x64.png",
              width: 64,
              height: 64,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: localizations.tabExploreTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.tabProfileTitle,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, AppLocalizations localizations) {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_getTitle(localizations)),
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.add_circle_outline),
              offset: const Offset(0, 20),
              position: PopupMenuPosition.under,
              color: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              onSelected: (value) {
                switch (value) {
                  case 0:
                    print(localizations.chatStartGroupChat);
                    break;
                  case 1:
                    print(localizations.chatAddFriend);
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/chat/qr_scan_page');
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
                    leading: const Icon(Icons.chat, color: Colors.white),
                    title: Text(
                      localizations.chatStartGroupChat,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: const Icon(Icons.person_add, color: Colors.white),
                    title: Text(
                      localizations.chatAddFriend,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: const Icon(Icons.qr_code_scanner, color: Colors.white),
                    title: Text(
                      localizations.chatScanQr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: const Icon(Icons.payment, color: Colors.white),
                    title: Text(
                      localizations.chatPayment,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 4:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(_getTitle(localizations)),
          centerTitle: true,
        );
      default:
        return AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_getTitle(localizations)),
        );
    }
  }
}
