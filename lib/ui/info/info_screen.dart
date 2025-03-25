import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mate/ui/info/connect_screen.dart';

import '../../utils/colors.dart';
import '../service/auth_service.dart';
import '../widget/header.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isNicknameValid = false;
  DateTime? selectedDate;
  String nickName = "";

  final AuthService _authService = AuthService();

  void _onTextChanged(String value) {
    setState(() {
      isNicknameValid = value.isNotEmpty && value.length <= 20;
      nickName = value;
    });
  }

  void _showDatePicker(BuildContext context) {
    _focusNode.unfocus();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: whiteColor,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                maximumYear: DateTime.now().year,
                minimumYear: DateTime.now().year - 100,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
              ),
            ),
            // Close Button
            CupertinoButton(
              color: greenColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('완료', style: TextStyle(color: whiteColor)),
            )
          ],
        ),
      ),
    );
  }

  String _formattedDate() {
    if (selectedDate == null) return 'YYYY-MM-DD';
    return '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                  bottom: 24
              ),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Header(back: true, close: false),
                        const SizedBox(height: 25),
                        const Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: greenColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nicknameController,
                          focusNode: _focusNode,
                          onChanged: _onTextChanged,
                          maxLength: 16,
                          decoration: InputDecoration(
                            hintText: '닉네임 입력',
                            filled: true,
                            fillColor: darkGrayColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            counterText: '',
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '생년월일',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: greenColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _showDatePicker(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: darkGrayColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formattedDate(),
                              style: TextStyle(
                                color: selectedDate == null ? lightGrayColor : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Spacer(),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isNicknameValid && selectedDate != null
                                  ? () {
                                      _authService.setMyInfo(nickName, selectedDate!);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const ConnectScreen()),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '커플 연결하러 가기',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
