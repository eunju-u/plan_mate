import 'package:flutter/cupertino.dart';

// 로그 스타일 가이드
// 태그1 : 기능 단위
// 태그2 : 메소드명
// 태그3 : 내용

void log(String function, String method, String content) {
  var msg = "_[$function][$method][eunjulee] $content";
  print(msg);
}

void logD(String function, String method,  String content) {
  var msg = "[$function][$method][eunjulee] $content";
  debugPrint(msg);
}
