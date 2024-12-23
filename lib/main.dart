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
import 'pages/chat/mobile_scanner.dart';
import 'system/device_info.dart';
import 'services/heartbeat.dart';
import 'package:flutter/services.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'system/permission.dart';
import 'pages/profile/printer.dart';

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
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      localizationsDelegates: const [
        AppLocalizations.delegate, // 添加本地化委托
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // 英文
        Locale('zh'), // 中文
      ],
      locale: const Locale('en'), // 默认语言
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
        
        // Check if it's a profile/printer route
        if (settings.name == '/profile/printer') {
          return MaterialPageRoute(
            builder: (context) => const PrinterPage(),
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
      // locale: Provider.of<LocaleProvider>(context).locale,
      // supportedLocales: AppLocalizations.supportedLocales,
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
      // 获取当前语言
      final deviceLocale = Localizations.localeOf(context);
      print('Current locale: ${deviceLocale.languageCode}-${deviceLocale.countryCode}');

      // 获取系统语言优先级列表
      final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
      for (var locale in systemLocales) {
        print('Preferred locale: ${locale.languageCode}-${locale.countryCode}');
      }

      PermissionUtil.requestLocationPermission(context);


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
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                print('chatbot pressed');
              },
            ),
            CustomPopup(
              barrierColor: Colors.black12,
              backgroundColor: Colors.black,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              contentDecoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPopupMenuItem(
                    icon: Icons.chat,
                    title: localizations.chatStartGroupChat,
                    onTap: () => print(localizations.chatStartGroupChat),
                  ),
                  _buildPopupMenuItem(
                    icon: Icons.person_add,
                    title: localizations.chatAddFriend,
                    onTap: () => print(localizations.chatAddFriend),
                  ),
                  _buildPopupMenuItem(
                    icon: Icons.qr_code_scanner,
                    title: localizations.chatScanQr,
                    onTap: () => Navigator.pushNamed(context, '/chat/qr_scan_page'),
                  ),
                  _buildPopupMenuItem(
                    icon: Icons.payment,
                    title: localizations.chatPayment,
                    onTap: () => print(localizations.chatPayment),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.add_circle_outline),
              ),
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

  Widget _buildPopupMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
