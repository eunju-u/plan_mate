import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/ui/popup/popup.dart';

import '../../enums/popup_status.dart';

// 전역에서 노출되도록 별도의 클래스 생성
class BottomPopup {
  static void show(BuildContext context, PopupStatus status) {
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
}
