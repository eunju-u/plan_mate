import 'package:flutter/material.dart';
import 'package:plan_mate/ui/widget/schedule_card_cell.dart';

import '../../enums/schedule_status.dart';
import '../data/schedule_card_data.dart';
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
                    // 일정 등록 동작
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScheduleSetScreen(dateType: dateType)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBF4DB),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xffff96e2a),
                  ),
                  label: const Text(
                    '일정 추가',
                    style: TextStyle(color: Color(0xFFF96E2A)),
                  ),
                ),
                const SizedBox(height: 5),
                if (list.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      // 일정 등록 동작
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0ECE3),
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
