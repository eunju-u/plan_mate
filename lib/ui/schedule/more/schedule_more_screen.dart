import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enums/schedule_status.dart';
import '../../../utils/colors.dart';
import '../../widget/header.dart';
import '../../widget/schedule_card_cell.dart';
import '../schedule_viewmodel.dart';

class ScheduleMoreScreen extends StatefulWidget {
  final ScheduleStatus dateType;

  const ScheduleMoreScreen({super.key, required this.dateType});

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
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Header(back: false, close: true),
              const SizedBox(height: 25),
              ListView.builder(
                  key: const PageStorageKey<String>('scheduleMoreScreenView'),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ScheduleCardCell(data: list[index], isFromHome: false);
                  }),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}