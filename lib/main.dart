import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/main_view.dart';
import 'package:plan_mate/ui/schedule/schedule_viewmodel.dart';
import 'package:plan_mate/ui/service/auth_service.dart';

import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // 날짜 데이터 초기화

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ko_KR', null); // 한국어 날짜 형식 초기화

  runApp(
    ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(AuthService()),
      child: const MainView(),
    ),
  );
}
