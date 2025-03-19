import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main_view.dart';
import '../service/auth_service.dart';

//스플래쉬다음으로 하기
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6E3),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'plan mate',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF387478)),
              ),
            ),
            Expanded(
              child: LoginButton(
                color: Colors.white,
                icon: 'assets/icons_google.png',
                text: '구글로 시작하기',
                textColor: Colors.black,
                onPressed: () async {
                  User? user = await _authService.signInWithGoogle();
                  if (user != null) {
                    // 로그인 성공 시 Main 화면 노출
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BottomNavBar()),
                      );
                    }
                  } else {
                    print("eunjulee Google Sign-In canceled or failed.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final String icon;
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    this.textColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // 버튼의 외부 여백 설정
        child: SizedBox(
          width: double.infinity, // 가로로 꽉 채우기
          child: ElevatedButton(
            onPressed: () async {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color, // 버튼 텍스트 색상
              surfaceTintColor: color,
              foregroundColor: color,
              padding: const EdgeInsets.symmetric(vertical: 12), // 버튼 내부 패딩
              elevation: 2, // 버튼 그림자
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 10), // 텍스트와 아이콘 사이 간격
                Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
