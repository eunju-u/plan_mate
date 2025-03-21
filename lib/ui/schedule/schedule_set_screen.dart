import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../enums/schedule_status.dart';
import '../service/auth_service.dart';
import '../widget/header.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../widget/switch_widget.dart';

class ScheduleSetScreen extends StatefulWidget {
  final ScheduleStatus dateType;

  const ScheduleSetScreen({
    super.key,
    required this.dateType,
  });

  @override
  State<ScheduleSetScreen> createState() => _ScheduleSetScreenState();
}

class _ScheduleSetScreenState extends State<ScheduleSetScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String content = "";
  DateTime? selectedDate;
  bool isRequestPartner = false;
  bool isReceivePush = false;

  DateTime get _defaultDate {
    final DateTime today = DateTime.now();
    if (widget.dateType == ScheduleStatus.yesterday) {
      return today.subtract(const Duration(days: 1));
    } else if (widget.dateType == ScheduleStatus.tomorrow) {
      return today.add(const Duration(days: 1));
    }
    return today; // 기본값은 오늘 날짜
  }

  String _formattedDate() {
    final DateTime displayDate = selectedDate ?? _defaultDate;
    return DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(displayDate);
  }

  void _onTextChanged(String value) {
    setState(() {
      content = value;
    });
  }

  void setSchedule() {
    _authService.addSchedule(content, selectedDate ?? _defaultDate, isRequestPartner, isReceivePush);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 24),
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(back: false, close: true),
                    const SizedBox(height: 25),
                    const Text(
                      '날짜/시간 선택',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF387478),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? dateTime = await showOmniDateTimePicker(context: context, initialDate  : _defaultDate);
                        setState(() {
                          selectedDate = dateTime;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0x47f8eed1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formattedDate(),
                          style: TextStyle(
                            color: selectedDate == null ? const Color(0xFF9E9E9E) : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '내용',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF387478),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nicknameController,
                      focusNode: _focusNode,
                      onChanged: _onTextChanged,
                      maxLength: 40,
                      decoration: InputDecoration(
                        hintText: '일정 입력',
                        filled: true,
                        fillColor: const Color(0x47f8eed1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '상대방에게 승락 요청하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF387478),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            '상대방에게 일정을 요청합니다. 상대가 수락시 일정에 추가됩니다.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SwitchWidget(
                          value: isRequestPartner,
                          onChanged: (bool newValue) {
                            setState(() {
                              isRequestPartner = newValue;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '알려주기 허용하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF387478),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            '알림을 받을 수 있습니다.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SwitchWidget(
                          value: isReceivePush,
                          onChanged: (bool newValue) {
                            setState(() {
                              isReceivePush = newValue;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Spacer(),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setSchedule();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF387478),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '일정 추가 완료',
                            style: TextStyle(
                              color: Colors.white,
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
            ]),
          ),
        ),
      ),
    );
  }
}
