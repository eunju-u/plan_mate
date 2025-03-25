import 'package:flutter/material.dart';
import 'package:plan_mate/ui/widget/schedule_card_cell.dart';
import 'package:plan_mate/utils/colors.dart';

import '../../enums/schedule_status.dart';
import '../data/schedule_card_data.dart';
import '../schedule/more/schedule_more_screen.dart';
import '../schedule/schedule_set_screen.dart';

class ScheduleCard extends StatelessWidget {
  final Color? color;
  final List<ScheduleData> list;
  final ScheduleStatus dateType;

  const ScheduleCard({
    super.key,
    this.color,
    required this.dateType,
    required this.list,
  });

  DateTime get _defaultDate {
    final DateTime today = DateTime.now();
    if (dateType == ScheduleStatus.yesterday) {
      return today.subtract(const Duration(days: 1));
    } else if (dateType == ScheduleStatus.tomorrow) {
      return today.add(const Duration(days: 1));
    }
    return today; // 기본값은 오늘 날짜
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          if (list.isNotEmpty)
            for (int i = 0; i < (list.length > 3 ? 3 : list.length); i++) ...[
              Expanded(flex: 2, child: ScheduleCardCell(data: list[i])),
              const SizedBox(height: 8),
            ],
          if (list.isNotEmpty)
            // 더미 항목 추가
            if (list.length < 3)
              for (int i = list.length; i < 3; i++) ...[
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 8),
              ],
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // 일정 등록 화면
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScheduleSetScreen(dateTime: _defaultDate)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightLimeColor,
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: orangeColor,
                  ),
                  label: const Text(
                    '일정 추가',
                    style: TextStyle(color: orangeColor),
                  ),
                ),
                const SizedBox(height: 5),
                if (list.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      // 일정 더보기 화면
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScheduleMoreScreen(dateType: dateType, dateTime: _defaultDate)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBeigeColor,
                      elevation: 0,
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                    label: const Text(
                      '더보기',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
