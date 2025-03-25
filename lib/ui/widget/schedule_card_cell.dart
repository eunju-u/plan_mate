import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_mate/ui/widget/tag.dart';

import '../data/schedule_card_data.dart';
import '../service/auth_service.dart';

class ScheduleCardCell extends StatelessWidget {
  final Color? color;
  final ScheduleData? data;
  final bool? isFromHome;

  const ScheduleCardCell({
    super.key,
    this.color,
    this.data,
    this.isFromHome,
  });

  Future<Map<String, dynamic>> _isCreatorCurrentUser(AuthService authService, String? creator) async {
    if (creator == null || creator.isEmpty) return {'nickname': '', 'isCurrentUser': false};

    User? currentUser = await authService.getCurrentUser();
    if (currentUser == null) return {'nickname': '', 'isCurrentUser': false};

    bool isCurrentUser = creator == currentUser.email;
    String nickname = isCurrentUser ? await authService.getNickName() : await authService.getPartnerNickName();

    return {'nickname': nickname, 'isCurrentUser': isCurrentUser};
  }

  String formatTimestampToTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return FutureBuilder<Map<String, dynamic>>(
        future: _isCreatorCurrentUser(authService, data?.creator),
        builder: (context, snapshot) {
          final String creatorText = snapshot.data?['nickname'] ?? '';
          final bool isCreatorCurrentUser = snapshot.data?['isCurrentUser'] ?? false;
          final Color textColor = isCreatorCurrentUser ? const Color(0xFFFBF4DB) : const Color(0xFFF0ECE3);
          final String formattedTime = data?.date != null
              ? formatTimestampToTime(data!.date)
              : "00:00";

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data?.content ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF387478),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(width: 3),
                Tag(color: textColor, text: creatorText),
              ],
            ),
          );
        });
  }
}
