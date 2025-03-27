import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plan_mate/utils/log.dart';

import '../data/schedule_card_data.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<bool> isLogin() async {
    return await getUserDocument() != null;
  }

  // 구글 로그인
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // 사용자가 로그인 창을 닫거나 취소한 경우
      if (googleUser == null) {
        _signOut();
        return null; // 로그인 취소 처리
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase 로그인
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      User user = userCredential.user!;
      String email = user.email ?? "";

      String code = await generateCopyCode();

      // Firestore에 사용자 정보 저장
      await _firestore.collection('users').doc(email).set({
        'copyCode': code,
        'partner': null,
        'createdDate': FieldValue.serverTimestamp(), // 서버 시간으로 설정
        'nickName': "",
        'birthDay': null,
        'startCoupleDate': null,
        'withText': "행복하자",
        'schedules': []
      });

      return user;
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  // copyCode 만들기
  Future<String> generateCopyCode() async {
    const length = 10;
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = "";

    bool isUnique = false;
    while (!isUnique) {
      // 고유 코드 생성
      code = List.generate(length, (index) => characters[Random().nextInt(characters.length)]).join();

      // Firestore에서 중복 여부 확인
      final querySnapshot = await _firestore.collection('users').where('copyCode', isEqualTo: code).limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        isUnique = true; // 중복이 없으면 종료
      }
    }
    log("AuthService", "generateCopyCode", "code : $code");
    return code;
  }

  // 내 정보 입력
  Future<void> setMyInfo(String nickName, DateTime birthDay) async {
    User? user = await getCurrentUser();
    if (user == null) return;

    // Firestore에 사용자 정보 저장
    await _firestore.collection('users').doc(user.email).update({
      'nickName': nickName,
      'birthDay': birthDay,
    });
  }

  // 내 정보 입력
  Future<void> setCoupleInfo(DateTime startCoupleDate) async {
    User? user = await getCurrentUser();
    if (user == null) return;

    // Firestore에 사용자 정보 저장
    await _firestore.collection('users').doc(user.email).update({
      'startCoupleDate': startCoupleDate,
    });
  }

  Future<DocumentSnapshot?> getUserDocument() async {
    try {
      User? user = await getCurrentUser();
      if (user == null) return null;

      final docSnapshot = await _firestore.collection('users').doc(user.email).get();

      if (docSnapshot.exists) {
        return docSnapshot;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user document: $e");
      return null;
    }
  }

  Future<String> getNickName() async {
    final docSnapshot = await getUserDocument();
    if (docSnapshot == null) return "";

    final data = docSnapshot.data() as Map<String, dynamic>?;
    final nickName = data?['nickName'];

    return nickName != null && nickName.isNotEmpty ? nickName : "";
  }

  Future<String> getCopyCode() async {
    final docSnapshot = await getUserDocument();
    if (docSnapshot == null) return "";

    final data = docSnapshot.data() as Map<String, dynamic>?;
    final copyCode = data?['copyCode'];

    return copyCode != null && copyCode.isNotEmpty ? copyCode : "";
  }

  Future<String> getPartner() async {
    final docSnapshot = await getUserDocument();
    if (docSnapshot == null) return "";

    final data = docSnapshot.data() as Map<String, dynamic>?;
    return data?['partner'] ?? "";
  }

  // 상대방의 nickName을 가져오는 함수
  Future<String> getPartnerNickName() async {
    try {
      // 현재 로그인된 사용자의 partner 이메일을 가져옴
      String partnerEmail = await getPartner();

      if (partnerEmail.isEmpty) {
        return ""; // 파트너가 없는 경우 빈 문자열 반환
      }

      // Firestore에서 파트너 문서를 가져옴
      final partnerDoc = await _firestore.collection('users').doc(partnerEmail).get();

      if (partnerDoc.exists) {
        // 문서에서 'nickName' 값을 가져옴
        final data = partnerDoc.data();
        return data?['nickName'] ?? ""; // nickName이 없으면 빈 문자열 반환
      } else {
        return ""; // 파트너 문서가 없으면 빈 문자열 반환
      }
    } catch (e) {
      print("Error fetching partner's nickname: $e");
      return ""; // 에러 발생 시 빈 문자열 반환
    }
  }

  // 상대방의 커플 날짜 가져오는 함수
  Future<Timestamp?> getPartnerStartCoupleDate() async {
    try {
      // 현재 로그인된 사용자의 partner 이메일을 가져옴
      String partnerEmail = await getPartner();

      if (partnerEmail.isEmpty) {
        return null; // 파트너가 없는 경우 빈 문자열 반환
      }

      // Firestore에서 파트너 문서를 가져옴
      final partnerDoc = await _firestore.collection('users').doc(partnerEmail).get();

      if (partnerDoc.exists) {
        log("home", "getPartnerStartCoupleDate", "11");

        // 문서에서 'startCoupleDate' 값을 가져옴
        final data = partnerDoc.data();
        return data?['startCoupleDate'] ?? ""; // startCoupleData이 없으면 빈 문자열 반환
      } else {
        return null; // 파트너 문서가 없으면 빈 문자열 반환
      }
    } catch (e) {
      print("Error fetching partner's startCoupleDate: $e");
      return null; // 에러 발생 시 빈 문자열 반환
    }
  }

  // 커플된 날짜
  Future<Timestamp?> getStartCoupleDate() async {
    final docSnapshot = await getUserDocument();
    if (docSnapshot == null) return null;

    final data = docSnapshot.data() as Map<String, dynamic>?;
    if (data == null) return null;

    final startCoupleDate = data['startCoupleDate'];
    if (startCoupleDate == null) return null;

    return data['startCoupleDate'];
  }

  // 문구
  Future<String?> getWithText() async {
    final docSnapshot = await getUserDocument();
    if (docSnapshot == null) return "";

    final data = docSnapshot.data() as Map<String, dynamic>?;
    return data?['withText'] ?? "";
  }

  Future<bool> hasPartner() async {
    return await getPartner() != "";
  }

  Future<bool> hasNickName() async {
    return await getNickName() != "";
  }

  Future<bool> hasStartCoupleDate() async {
    return await getStartCoupleDate() != null;
  }

  void _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // 상대방의 copyCode로 연결
  Future<bool> connectPartner(String inputCopyCode) async {
    try {
      // 현재 로그인한 사용자 ID
      String currentUserId = _auth.currentUser!.email!;

      // Firestore에서 copyCode로 상대방 검색
      QuerySnapshot querySnapshot = await _firestore.collection('users').where('copyCode', isEqualTo: inputCopyCode).limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        log("AuthService", "connectPartner", "해당 copyCode를 가진 사용자가 없습니다.");
        return false;
      }

      // 상대방 정보 가져오기
      var partnerDoc = querySnapshot.docs.first;
      String partner = partnerDoc.id;

      // 자기 자신과 연결하려는 경우 방지
      if (currentUserId == partner) {
        log("AuthService", "connectPartner", "자기 자신과는 연결할 수 없습니다.");
        return false;
      }

      // Firestore에서 현재 사용자와 상대방의 partner 업데이트
      await _firestore.collection('users').doc(currentUserId).update({
        'partner': partner,
      });

      await _firestore.collection('users').doc(partner).update({
        'partner': currentUserId,
      });

      log("AuthService", "connectPartner", "성공적으로 연결되었습니다! 상대방 ID: $partner");
      return true;
    } catch (e) {
      log("AuthService", "connectPartner", "파트너 연결 중 오류 발생: $e");
      return false;
    }
  }

  // Future<void> updateSchedule(String coupleId, String content, DateTime date, String creatorId) async {
  //   await _firestore.collection('schedules').doc(coupleId).update({
  //     'schedules': FieldValue.arrayUnion([
  //       {
  //         'content': content,
  //         'date': date,
  //         'creatorId': creatorId,
  //       }
  //     ])
  //   });
  // }

  // schedules 컬렉션에서 데이터를 가져오기
  Future<List<ScheduleData>> getSchedules() async {
    try {
      final docSnapshot = await getUserDocument();
      if (docSnapshot == null) return List.empty();

      final data = docSnapshot.data() as Map<String, dynamic>?;
      final schedules = data?['schedules'];

      final querySnapshot = await _firestore.collection('schedules').get();

      // 문서들을 ScheduleData 객체로 변환하여 리스트로 반환
      return schedules.docs.map((doc) => ScheduleData.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching schedules: $e');
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }

  //일정 추가
  Future<void> addSchedule(String content, DateTime date, bool isRequestPartner, bool isReceivePush) async {
    try {
      User? user = await getCurrentUser();
      if (user == null) return;

      String userEmail = user.email!;
      String partnerEmail = await getPartner();
      if (partnerEmail.isEmpty) {
        log("AuthService", "connectPartner", "파트너가 없습니다.");
        return;
      }

      DocumentReference scheduleRef = _firestore.collection('schedules').doc();

      await scheduleRef.set({
        'id': scheduleRef.id,
        'content': content,
        'date': Timestamp.fromDate(date),
        'creator': userEmail,
        'participants': [userEmail, partnerEmail],
        'isRequestPartner': isRequestPartner,
        'isReceivePush': isReceivePush,
      });

      // 사용자와 파트너의 schedules 필드 업데이트
      await _firestore.collection('users').doc(userEmail).update({
        'schedules': FieldValue.arrayUnion([scheduleRef.id])
      });
      await _firestore.collection('users').doc(partnerEmail).update({
        'schedules': FieldValue.arrayUnion([scheduleRef.id])
      });

      print("스케줄이 성공적으로 추가되었습니다.");
    } catch (e) {
      print("스케줄 추가 중 오류 발생: $e");
    }
  }

  /// 일정 수정
  Future<void> updateSchedule(String scheduleId, String updatedContent, DateTime updatedDate, bool isRequestPartner, bool isReceivePush) async {
    try {
      log("AuthService", "updateSchedule", "스케쥴 수정 시작 scheduleId : $scheduleId");

      User? user = await getCurrentUser();
      if (user == null) return;

      String partnerEmail = await getPartner();
      if (partnerEmail.isEmpty) {
        return;
      }

      // Firestore 참조 가져오기
      DocumentReference scheduleRef = _firestore.collection('schedules').doc(scheduleId);

      // 스케줄 업데이트
      await scheduleRef.update({
        'content': updatedContent,
        'date': Timestamp.fromDate(updatedDate),
        'isRequestPartner': isRequestPartner,
        'isReceivePush': isReceivePush,
      });

      log("AuthService", "updateSchedule", "스케줄이 성공적으로 수정되었습니다.");
    } catch (e) {
      log("AuthService", "updateSchedule", "스케줄 수정 중 오류 발생: $e");
    }
  }

  // 일정 리스트 get
  Future<List<ScheduleData>> getSchedulesByDate(DateTime targetDate) async {
    try {
      final docSnapshot = await getUserDocument();
      if (docSnapshot == null) return [];

      final data = docSnapshot.data() as Map<String, dynamic>?;
      final scheduleIds = List<String>.from(data?['schedules'] ?? []);

      //collection user에 schedule는 없는데 collection schedule에 값이 있어 일정 데이터가 나와서 예외처리
      if (scheduleIds.isEmpty) return [];

      // 사용자 이메일 가져오기
      User? user = await getCurrentUser();
      if (user == null) return [];
      String userEmail = user.email!;

      // 날짜 범위 계산 (하루의 시작과 끝)
      DateTime startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));
      // Firestore에서 participants 필드에 userEmail이 포함되고, 날짜가 targetDate에 해당하는 스케줄을 가져오는 쿼리
      final querySnapshot = await _firestore
          .collection('schedules')
          .where('participants', arrayContains: userEmail) // 참가자에 사용자 이메일 포함
          .where('date', isGreaterThanOrEqualTo: startOfDay) // 날짜가 시작일 이후
          .where('date', isLessThan: endOfDay) // 날짜가 끝일 이전
          .orderBy('date', descending: false) // 날짜를 기준으로 오름차순 정렬
          .get();
      log("AuthService", "getSchedulesByDate", "querySnapshot: ${querySnapshot.docs}");

      // 쿼리 결과를 ScheduleData 객체 리스트로 변환하여 반환
      return querySnapshot.docs
          .map((doc) => ScheduleData.fromFirestore(doc)) // ScheduleData.fromFirestore는 Firestore에서 가져온 데이터를 ScheduleData 객체로 변환하는 함수
          .toList();
    } catch (e) {
      print('ejlee5 Error fetching schedules by date: $e');
      return []; // 에러가 발생하면 빈 리스트 반환
    }
  }
}
