import 'package:flutter/material.dart';

import '../../enums/schedule_status.dart';
import '../data/schedule_card_data.dart';
import '../service/auth_service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final AuthService authService;

  Map<String, List<ScheduleData>> _schedules = {
    ScheduleStatus.yesterday.name: [],
    ScheduleStatus.today.name: [],
    ScheduleStatus.tomorrow.name: [],
  };

  Map<String, List<ScheduleData>> get schedules => _schedules;

  ScheduleViewModel(this.authService);

  Future<void> fetchSchedules() async {
    try {
      AuthService authService = AuthService();
      DateTime today = DateTime.now();
      DateTime yesterday = today.subtract(const Duration(days: 1));
      DateTime tomorrow = today.add(const Duration(days: 1));

      // 어제, 오늘, 내일의 스케줄을 각각 가져옴
      List<ScheduleData> yesterdaySchedules = await authService.getSchedulesByDate(yesterday);
      List<ScheduleData> todaySchedules = await authService.getSchedulesByDate(today);
      List<ScheduleData> tomorrowSchedules = await authService.getSchedulesByDate(tomorrow);

      // 상태 업데이트
      _schedules = {
        ScheduleStatus.yesterday.name: yesterdaySchedules,
        ScheduleStatus.today.name: todaySchedules,
        ScheduleStatus.tomorrow.name: tomorrowSchedules,
      };
      notifyListeners();
    } catch (e) {
      print('eunjulee Error fetching schedules: $e');
    }
  }
}
