import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_mate/ui/widget/tag.dart';

import '../../utils/colors.dart';
import '../data/schedule_card_data.dart';
import '../schedule/schedule_set_screen.dart';
import '../service/auth_service.dart';

class ScheduleCardCell extends StatelessWidget {
  final Color? color;
  final ScheduleData? data;

  const ScheduleCardCell({
    super.key,
    this.color,
    this.data,
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
          final Color textColor = isCreatorCurrentUser ? lightLimeColor : lightBeigeColor;
          final String formattedTime = data?.date != null ? formatTimestampToTime(data!.date) : "00:00";

          return GestureDetector(
            onTap: () {
              //TODO eunjulee
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleSetScreen(data: data, dateTime: data?.date)),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: whiteColor,
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
                          children: [
                            Text(
                              data?.content ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: greenColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 13,
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
            ),
          );
        });
  }
}
