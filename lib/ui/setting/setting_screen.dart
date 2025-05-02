import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plan_mate/ui/login/login_screen.dart';

import '../../utils/colors.dart';
import '../component/arrow_cell.dart';
import '../component/center_popup.dart';
import '../component/header_bar.dart';
import '../service/auth_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  final AuthService _authService = AuthService();
  String _version = "";

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  void getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = "${packageInfo.version} (${packageInfo.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(
        title: "설정",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20), // 10만큼 간격 추가
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "앱 정보",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "400m",
                    fontWeight: FontWeight.bold, // Bold 적용
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "현재 버전 $_version",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "400m",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15), // 좌우 15
              child: Container(
                  height: 1, // 선의 두께
                  color: lightGrayColor2 // 선의 색상
                  ),
            ),
            const SizedBox(height: 15), // 10만큼 간격 추가
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "알림",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "400m",
                    fontWeight: FontWeight.bold, // Bold 적용
                  ),
                ),
              ),
            ),
            ArrowCell(
              title: "알림 설정",
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15), // 좌우 15
              child: Container(
                  height: 1, // 선의 두께
                  color: lightGrayColor2 // 선의 색상
                  ),
            ),
            const SizedBox(height: 15), // 10만큼 간격 추가
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "관리",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "400m",
                    fontWeight: FontWeight.bold, // Bold 적용
                  ),
                ),
              ),
            ),
            ArrowCell(
              title: "로그아웃",
              onTap: () {
              },
            ),
            ArrowCell(
              title: "회원탈퇴",
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
