import 'package:flutter/cupertino.dart';
import 'package:plan_mate/ui/calendar/widget/calendar_widget.dart';
import 'package:plan_mate/ui/calendar/widget/calendar_style.dart';
import 'package:plan_mate/utils/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/utils/colors.dart';

import '../data/schedule_card_data.dart';
import '../service/auth_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final AuthService _authService = AuthService();
  List<ScheduleData> _selectedSchedules = []; // 선택한 날짜의 일정 저장
  List<ScheduleData> _schedules = []; // 일정 데이터를 저장할 리스트
  bool _isLoading = false; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchSchedulesForMonth(_selectedDay!);
  }

  // 한 달치 일정 가져오기
  void _fetchSchedulesForMonth(DateTime targetMonth) async {
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    final schedules = await _authService.getSchedulesForMonth(targetMonth);
    setState(() {
      _schedules = schedules;
      _selectedSchedules = _getEventsForDay(_selectedDay!);
      _isLoading = false; // 로딩 종료
    });
  }

  // 특정 날짜의 일정 필터링
  List<ScheduleData> _getEventsForDay(DateTime day) {
    return _schedules.where((schedule) {
      return isSameDay(schedule.date, day);
    }).toList();
  }

  // 날짜 선택 시 일정 업데이트
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedSchedules = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar<ScheduleData>(
                firstDay: firstDay,
                lastDay: lastDay,
                locale: "ko-KR",
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => _getEventsForDay(day),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                calendarStyle: const CalendarStyle(outsideDaysVisible: false),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  _fetchSchedulesForMonth(focusedDay); // 달 변경 시 일정 갱신
                },
              ),
              const SizedBox(height: 8.0),
              if (_isLoading) // 로딩 상태에 따른 인디케이터 표시
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedSchedules.length,
                  itemBuilder: (context, index) {
                    final content = _selectedSchedules[index].content;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(10.0), border: Border.all(width: 1.0, color: limeColor)),
                      child: ListTile(
                        title: Text(content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: greenColor,
                              height: 1,
                            )),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
