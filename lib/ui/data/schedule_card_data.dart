import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleData {
  final String id;
  final String content;
  final DateTime date;
  final String creator;
  final List<String> participants;
  final bool isRequestPartner;
  final bool isReceivePush;

  ScheduleData({
    required this.id,
    required this.content,
    required this.date,
    required this.creator,
    required this.participants,
    required this.isRequestPartner,
    required this.isReceivePush,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) => ScheduleData(
        id: json['id'],
        content: json['content'],
        date: json['date'],
        creator: json['creator'],
        participants: json['participants'],
        isRequestPartner: json['isRequestPartner'],
        isReceivePush: json['isReceivePush'],
      );

  // Firestore 데이터로부터 ScheduleData 객체 생성
  factory ScheduleData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // `Timestamp`를 `DateTime`으로 변환
    DateTime dateTime = (data['date'] as Timestamp).toDate();

    return ScheduleData(
      id: data['id'] ?? '',
      content: data['content'] ?? '',
      date: dateTime,
      creator: data['creator'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      isRequestPartner: data['isRequestPartner'] ?? false,
      isReceivePush: data['isReceivePush'] ?? false,
    );
  }
}
