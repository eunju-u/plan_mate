import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/enums/popup_status.dart';
import 'package:plan_mate/ui/schedule/schedule_screen.dart';

import '../data/schedule_card_data.dart';
import '../popup/popup.dart';
import '../service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  bool isLogin = false;
  String forDays = '우리는 0일째';

  @override
  void initState() {
    super.initState();
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

//0x47f8eed1
//0xFFF1F3C2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Text(forDays, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF387478)), textAlign: TextAlign.center),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffffffff),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(100, 103, 96, 0.1),
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text(
                          '우리는 커플이지롱',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF387478),
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
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading state
                          }
                          if (snapshot.hasData) {
                            final isLoggedIn = snapshot.data![0];
                            final hasNickName = snapshot.data![1];
                            final hasPartner = snapshot.data![2];

                            if (isLoggedIn && !hasNickName) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the desired screen when the user does not have a partner
                                  _showBottomSheet(PopupStatus.myInfo);
                                },
                                child: const Row(
                                  children: [ Text(
                                    '내 정보 입력이 필요해요.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF387478),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),  const Icon(Icons.arrow_right_alt_rounded, color: Color(0xFF387478))],
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
                                    color: Color(0xFF387478),
                                  ),
                                  textAlign: TextAlign.center,
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

                      // onTap: () async {
                      //   bool isLogin = await _authService.isLogin();
                      //   bool hasNickName = await _authService.hasNickName();
                      //   bool hasPartner = await _authService.hasPartner();
                      //   if (isLogin) {
                      //     if (!hasNickName) {
                      //       _showBottomSheet(PopupStatus.myInfo);
                      //     } else if (!hasPartner) {
                      //       _showBottomSheet(PopupStatus.connection);
                      //     }
                      //   }
                      // },
                      const SizedBox(height: 40),
                      FutureBuilder<List<ScheduleData>>(
                        future: _authService.getSchedules(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // 로딩 상태 표시
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Text('스케줄 데이터를 불러올 수 없습니다.');
                          } else {
                            print("eunjulee ${snapshot.data!}");
                          }
                          return SizedBox(height: 450, child: ScheduleScreen(scheduleData: snapshot.data!)); // 데이터 전달
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
