import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_container/tab_container.dart';

import '../../enums/schedule_status.dart';
import '../data/schedule_card_data.dart';
import 'schedule_viewmodel.dart';
import '../widget/schedule_card.dart';

class ScheduleScreen extends StatefulWidget {
  final List<ScheduleData> scheduleData; // 전달된 데이터를 받을 변수

  const ScheduleScreen({super.key, required this.scheduleData});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late TextTheme textTheme;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3, initialIndex: 1);

    // ViewModel 초기 데이터 로드
    Future.microtask(() {
      final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
      viewModel.fetchSchedules();
    });
  }

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 날짜 비교
  bool isSameDate(DateTime scheduleDate, DateTime targetDate) {
    return scheduleDate.year == targetDate.year && scheduleDate.month == targetDate.month && scheduleDate.day == targetDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);

    return Column(
      children: [
        SizedBox(
          child: AspectRatio(
            aspectRatio: 10 / 13,
            child: TabContainer(
              borderRadius: BorderRadius.circular(20),
              tabEdge: TabEdge.top,
              curve: Curves.easeIn,
              controller: _controller,
              transitionBuilder: (child, animation) {
                animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);
                return SlideTransition(
                  position: Tween(
                    begin: const Offset(0.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              colors: const <Color>[Color(0xFFF1F3C2), Color(0xFFF1F3C2), Color(0xFFF1F3C2)],
              selectedTextStyle: textTheme.bodyMedium?.copyWith(fontSize: 15.0),
              unselectedTextStyle: textTheme.bodyMedium?.copyWith(fontSize: 13.0),
              tabs: _getTabs(),
              children: [
                _buildScheduleList(viewModel, ScheduleStatus.yesterday),
                _buildScheduleList(viewModel, ScheduleStatus.today),
                _buildScheduleList(viewModel, ScheduleStatus.tomorrow),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildScheduleList(ScheduleViewModel viewModel, ScheduleStatus dateType) {
    final schedules = viewModel.schedules[dateType.name] ?? [];
    return ScheduleCard(dateType : dateType, list: schedules);
  }

  List<Widget> _getTabs() {
    return <Widget>[const Text('어제'), const Text('오늘'), const Text('내일')];
  }
}
