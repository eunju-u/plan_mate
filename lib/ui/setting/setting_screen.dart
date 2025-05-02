import 'package:flutter/material.dart';

import '../component/header_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HeaderBar(
        title: "설정",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
