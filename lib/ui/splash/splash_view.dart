import 'dart:async';

import 'package:flutter/material.dart';

import '../../main_view.dart';
import '../login/login_screen.dart';
import '../service/auth_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      bool isLogin = await _authService.isLogin();
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => isLogin ? const BottomNavBar() : const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   width: 110,
          //   height: 46,
          //   child: Image.asset('assets/splash/splash_bi_white.png'),
          // ),
        ],
      ),
    );
  }
}
