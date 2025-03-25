import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/enums/popup_status.dart';
import 'package:plan_mate/ui/info/connect_screen.dart';
import 'package:plan_mate/ui/info/couple_info_screen.dart';
import 'package:plan_mate/ui/info/info_screen.dart';
import 'package:plan_mate/utils/colors.dart';

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
    bool isCoupleInfo = widget.status == PopupStatus.coupleInfo;

    // 상태에 따라 노출할 문구 설정
    String text;
    String buttonText;
    if (isConnection) {
      text = '커플 연결을 해주세요.';
      buttonText = '연결하러 가기';
    } else if (isCoupleInfo) {
      text = '커플 정보를 입력해주세요.';
      buttonText = '커플 정보 입력하러 가기';
    } else {
      text = '내 정보를 입력해주세요.';
      buttonText = '내 정보 입력하러 가기';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            text,
            style: const TextStyle(fontSize: 15, color: grayColor),
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
                          MaterialPageRoute(
                              builder: (context) => isMyInfo
                                  ? const InfoScreen()
                                  : isConnection
                                      ? const ConnectScreen()
                                      : const CoupleInfoScreen()),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(color: greenColor, borderRadius: BorderRadius.circular(10.0)),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          MediaQuery.withClampedTextScaling(
                            maxScaleFactor: 1.3,
                            child: Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "400m",
                                fontSize: 15,
                                color: whiteColor,
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
        ],
      ),
    );
  }
}
