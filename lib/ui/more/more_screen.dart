import 'package:flutter/material.dart';
import 'package:plan_mate/ui/component/arrow_cell.dart';
import 'package:plan_mate/ui/more/profile_update_screen.dart';

import '../../utils/colors.dart';
import '../component/header_bar.dart';
import '../info/info_screen.dart';
import '../service/auth_service.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final AuthService _authService = AuthService();
  String nickName = "";

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    String fetchedNickName = await _authService.getNickName();
    setState(() {
      nickName = fetchedNickName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(title: "더보기", isBack: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ArrowCell(
              title: nickName.isNotEmpty ? nickName : "내 정보 입력이 필요해요.",
              textSize: 16,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nickName.isNotEmpty ? const ProfileUpdateScreen() : const InfoScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15), // 좌우 15
              child: Container(
                  height: 1, // 선의 두께
                  color: lightGrayColor2 // 선의 색상
                  ),
            )
          ],
        ),
      ),
    );
  }
}
