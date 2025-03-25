import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_container/tab_container.dart';

import '../../enums/schedule_status.dart';
import '../../main_view.dart';
import 'schedule_viewmodel.dart';
import '../widget/schedule_card.dart';
import '../../utils/log.dart';

class ScheduleScreen extends StatefulWidget {

  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
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
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log("home-schedule", "didChangeAppLifecycleState", "호출");
    if (state == AppLifecycleState.resumed) {
      // 다른 화면에서 돌아왔을 때 호출
      final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
      viewModel.fetchSchedules();
    }
  }

  //aos 안탐
  @override
  void didPopNext() {
    log("home-schedule", "didPopNext", "호출");
    // 다른 화면에서 돌아왔을 때 호출
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    viewModel.fetchSchedules();
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
