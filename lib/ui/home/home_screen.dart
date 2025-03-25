import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/enums/popup_status.dart';
import 'package:plan_mate/ui/schedule/schedule_screen.dart';

import '../../main_view.dart';
import '../../utils/colors.dart';
import '../../utils/log.dart';
import '../popup/popup.dart';
import '../service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware, WidgetsBindingObserver {
  final AuthService _authService = AuthService();

  bool isLogin = false;
  String forDays = '우리는 0일째';
  String withText = '행복하자';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    log("home", "initState", "호출");

  }

  @override
  void dispose() {
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
    log("home", "didChangeAppLifecycleState", "호출");
    if (state == AppLifecycleState.resumed) {
    }
  }

  @override
  void didPopNext() {
    log("home", "didPopNext", "호출");
    // 다른 화면에서 돌아왔을 때 호출
    _fetchUserData();
  }

  /// Fetches user data from Firestore and updates the UI.
  Future<void> _fetchUserData() async {
    try {
      final startCoupleDateData = await _authService.getStartCoupleDate();
      final withTextData = await _authService.getWithText();
      int startDate = calculateDateDifference(startCoupleDateData ?? Timestamp.now());
      setState(() {
        forDays = '우리는 $startDate일째';
        withText = withTextData ?? '행복하자';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _showBottomSheet(PopupStatus status) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // 상단 테두리 둥글게 설정
        ),
      ),
      builder: (BuildContext context) {
        return PopupWidget(status: status);
      },
    );
  }

  int calculateDateDifference(Timestamp timestamp) {
    // 현재 시간을 DateTime으로 가져오기
    DateTime now = DateTime.now();

    // Timestamp를 DateTime으로 변환
    DateTime targetDate = timestamp.toDate();

    // 두 날짜 간의 차이 계산 (일 단위)
    int differenceInDays = now.difference(targetDate).inDays;

    return differenceInDays;
  }

//0x47f8eed1
//0xFFF1F3C2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40),
                      Text(forDays, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: greenColor), textAlign: TextAlign.center),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(100, 103, 96, 0.1),
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          withText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: greenColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Spacer(),
                      FutureBuilder<List<bool>>(
                        future: Future.wait([
                          _authService.isLogin(),
                          _authService.hasNickName(),
                          _authService.hasPartner(),
                          _authService.hasStartCoupleDate(),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading state
                          }
                          if (snapshot.hasData) {
                            final isLoggedIn = snapshot.data![0];
                            final hasNickName = snapshot.data![1];
                            final hasPartner = snapshot.data![2];
                            final hasStartCoupleDate = snapshot.data![3];

                            if (isLoggedIn && !hasNickName) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the desired screen when the user does not have a partner
                                  _showBottomSheet(PopupStatus.myInfo);
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      '내 정보 입력이 필요해요.',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: greenColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.arrow_right_alt_rounded, color: greenColor)
                                  ],
                                ),
                              );
                            }

                            // Handle the condition where the user is logged in but does not have a partner
                            if (isLoggedIn && !hasPartner) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the desired screen when the user does not have a partner
                                  _showBottomSheet(PopupStatus.connection);
                                },
                                child: const Text(
                                  '파트너 연결이 필요해요.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: greenColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            if (isLoggedIn && !hasStartCoupleDate) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the desired screen when the user does not have a partner
                                  _showBottomSheet(PopupStatus.coupleInfo);
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      '커플 정보 입력이 필요해요.',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: greenColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.arrow_right_alt_rounded, color: greenColor)
                                  ],
                                ),
                              );
                            }

                            // If none of the conditions match, return an empty space
                            return const SizedBox.shrink();
                          }

                          // Handle error state or if data is null
                          return const Center(child: Text('Error loading data.'));
                        },
                      ),
                      const SizedBox(height: 40),
                      const SizedBox(height: 450, child: ScheduleScreen()) // 데이터 전달
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
