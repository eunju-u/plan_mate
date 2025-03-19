import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/enums/popup_status.dart';
import 'package:plan_mate/ui/info/connect_screen.dart';
import 'package:plan_mate/ui/info/info_screen.dart';

class PopupWidget extends StatefulWidget {
  const PopupWidget({super.key, required this.status});

  final PopupStatus status;

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    bool isConnection = widget.status == PopupStatus.connection;
    bool isMyInfo = widget.status == PopupStatus.myInfo;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            isMyInfo ? '정보를 입력해주세요.' : '커플 연결을 해주세요.',
            style: const TextStyle(fontSize: 15, color: Color(0xFF646760)),
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => isMyInfo ? const InfoScreen() : const ConnectScreen()),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(color: const Color(0xFF387478), borderRadius: BorderRadius.circular(10.0)),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          MediaQuery.withClampedTextScaling(
                            maxScaleFactor: 1.3,
                            child: Text(
                              isMyInfo ? '정보 입력하러 가기' : '연결하러 가기',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "400m",
                                fontSize: 15,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     // 로그인 화면으로 이동 또는 로그인 로직 추가
          //   },
          //   child: const Text('로그인하기'),
          // ),
        ],
      ),
    );
  }
}
