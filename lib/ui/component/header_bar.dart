import 'package:flutter/material.dart';

import '../setting/setting_screen.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBack; // leading(뒤로 가기 버튼) 표시 여부

  const HeaderBar({
    super.key,
    required this.title,
    this.isBack = true, // 기본값: true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      leading: isBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null, // leading을 표시하지 않을 경우 null 처리
      actions: !isBack
          ? [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingScreen()),
                  );
                },
              ),
            ]
          : null, // actions을 표시하지 않을 경우 null 처리
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
