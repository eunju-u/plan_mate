
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String content; // 일정 내용
  final DateTime date;  // 일정 날짜
  final String creatorId; // 생성자의 ID (유저 ID)

  Schedule({
    required this.content,
    required this.date,
    required this.creatorId,
  });

  // Firestore와의 데이터 변환을 위한 메서드
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      content: map['content'] as String,
      date: (map['date'] as Timestamp).toDate(), // Firestore의 Timestamp를 DateTime으로 변환
      creatorId: map['creatorId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'date': date, // DateTime 객체를 Firestore에 저장 가능한 형식으로 변환
      'creatorId': creatorId,
    };
  }
}