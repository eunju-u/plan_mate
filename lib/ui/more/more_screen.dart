import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/ui/component/arrow_cell.dart';
import 'package:plan_mate/ui/more/profile_update_screen.dart';

import '../component/header_bar.dart';
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
    getNickName();
  }

  void getNickName() async {
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
              title: nickName,
              onTap: () {
                MaterialPageRoute(builder: (context) => const ProfileUpdateScreen());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15), // 좌우 15
              child: Container(
                height: 1, // 선의 두께
                color: Colors.grey, // 선의 색상
              ),
            )
          ],
        ),
      ),
    );
  }
}
