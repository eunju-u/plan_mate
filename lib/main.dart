import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/main_view.dart';
import 'package:plan_mate/ui/schedule/schedule_viewmodel.dart';
import 'package:plan_mate/ui/service/auth_service.dart';

import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(AuthService()),
      child: const MainView(),
    ),
  );
}
