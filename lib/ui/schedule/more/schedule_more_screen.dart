import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../enums/schedule_status.dart';
import '../../../main_view.dart';
import '../../../utils/colors.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/log.dart';
import '../../data/schedule_card_data.dart';
import '../../service/auth_service.dart';
import '../../widget/header.dart';
import '../../widget/schedule_card_cell.dart';
import '../schedule_set_screen.dart';
import '../schedule_viewmodel.dart';

class ScheduleMoreScreen extends StatefulWidget {
  final ScheduleStatus dateType;
  final DateTime? dateTime;
  final List<ScheduleData> scheduleList;

  const ScheduleMoreScreen({
    super.key,
    required this.dateType,
    this.dateTime,
    required this.scheduleList,
  });

  @override
  State<ScheduleMoreScreen> createState() => _ScheduleMoreScreenState();
}

class _ScheduleMoreScreenState extends State<ScheduleMoreScreen> with RouteAware, WidgetsBindingObserver {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    log("schedule_more", "initState", "호출");
    loadSchedules();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      log("schedule_more", "didChangeAppLifecycleState", "호출");
      loadSchedules();
    }
  }

  @override
  void didPopNext() {
    log("schedule_more", "didPopNext", "호출");
    // 다른 화면에서 돌아왔을 때 호출
    loadSchedules();
  }

  void loadSchedules() {
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
                    return Dismissible(
                      key: Key(list[index].id),
                      // 각 항목의 고유 키 필요
                      direction: DismissDirection.endToStart,
                      // 오른쪽에서 왼쪽으로 스와이프
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red, // 스와이프 배경 색상
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete, // 휴지통 아이콘
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        // 삭제하려는 항목을 미리 저장
                        final deletedItem = list[index];

                        // 리스트에서 항목 제거
                        setState(() {
                          _authService.deleteSchedule(deletedItem.id);
                          list.removeAt(index);
                        });

                        showCustomToast(context, '삭제됨: ${deletedItem.content}');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('삭제됨: ${list[index].content}')),
                        // );
                      },
                      child: ScheduleCardCell(data: list[index]), // 기존 위젯
                    );
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
