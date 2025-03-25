import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enums/schedule_status.dart';
import '../../../utils/colors.dart';
import '../../widget/header.dart';
import '../../widget/schedule_card_cell.dart';
import '../schedule_set_screen.dart';
import '../schedule_viewmodel.dart';

class ScheduleMoreScreen extends StatefulWidget {
  final ScheduleStatus dateType;
  final DateTime? dateTime;

  const ScheduleMoreScreen({super.key, required this.dateType, this.dateTime});

  @override
  State<ScheduleMoreScreen> createState() => _ScheduleMoreScreenState();
}

class _ScheduleMoreScreenState extends State<ScheduleMoreScreen> {
  @override
  void initState() {
    super.initState();
    // ViewModel 초기 데이터 로드
    Future.microtask(() {
      final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
      viewModel.fetchSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);
    List list = viewModel.schedules[widget.dateType.name] ?? [];

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Container(
          color: limeColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Header(back: false, close: true),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ScheduleCardCell(data: list[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8);
                  },
                ),
              ),
              Container(
                color: limeColor,
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // 일정 등록 화면
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ScheduleSetScreen(dateTime: widget.dateTime)),
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}