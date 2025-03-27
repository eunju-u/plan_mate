
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plan_mate/ui/calendar/calendar_screen.dart';
import 'package:plan_mate/ui/home/home_screen.dart';
import 'package:plan_mate/ui/splash/splash_view.dart';
import 'package:plan_mate/utils/colors.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ko', 'KR'), // 한국어 추가
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // Material 위젯 번역
        GlobalWidgetsLocalizations.delegate, // 기본 위젯 번역
        GlobalCupertinoLocalizations.delegate, // iOS 스타일 위젯 번역 (Cupertino)
      ],
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: greenColor),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CalendarScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
        ],
      ),
    );
  }
}
