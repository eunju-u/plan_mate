import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../data/schedule_card_data.dart';
import '../service/auth_service.dart';
import '../widget/header.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../widget/switch_widget.dart';

class ScheduleSetScreen extends StatefulWidget {
  final DateTime? dateTime; // 설정된  날짜/시간 (수정시 필요)
  final ScheduleData? data; // 없으면 일정 추가 화면

  const ScheduleSetScreen({
    super.key,
    this.dateTime,
    this.data,
  });

  @override
  State<ScheduleSetScreen> createState() => _ScheduleSetScreenState();
}

class _ScheduleSetScreenState extends State<ScheduleSetScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? hintText = "";
  DateTime? selectedDate;
  bool isRequestPartner = false;
  bool isReceivePush = false;

  // DateTime get _defaultDate {
  //   final DateTime today = DateTime.now();
  //   if (widget.dateType == ScheduleStatus.yesterday) {
  //     return today.subtract(const Duration(days: 1));
  //   } else if (widget.dateType == ScheduleStatus.tomorrow) {
  //     return today.add(const Duration(days: 1));
  //   }
  //   return today; // 기본값은 오늘 날짜
  // }

  String _formattedDate() {
    final DateTime displayDate = selectedDate ?? widget.dateTime ?? DateTime.now();
    return DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(displayDate);
  }

  void setSchedule() {
    widget.data == null
        ? _authService.addSchedule(_controller.text, selectedDate ?? widget.dateTime ?? DateTime.now(), isRequestPartner, isReceivePush)
        : _authService.updateSchedule(widget.data?.id ?? "", _controller.text, selectedDate ?? widget.dateTime ?? DateTime.now(), isRequestPartner, isReceivePush);
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null && widget.data!.content.isNotEmpty) {
      _controller.text = widget.data!.content;
      hintText = null;
    } else {
      _controller.text = '';
      hintText = "일정 입력";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Controller와 FocusNode 해제
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
                        color: greenColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? dateTime = await showOmniDateTimePicker(context: context, initialDate: widget.dateTime ?? DateTime.now());
                        setState(() {
                          selectedDate = dateTime;
                        });
                      },
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
                    const SizedBox(height: 16),
                    const Text(
                      '내용',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: greenColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLength: 40,
                      decoration: InputDecoration(
                        hintText: hintText,
                        filled: true,
                        fillColor: darkGrayColor,
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
                        color: greenColor,
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
                              color: lightGrayColor,
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
                      '알림받기 허용하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: greenColor,
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
                              color: lightGrayColor,
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
                            backgroundColor: greenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.data == null ? '일정 추가 완료' : '일정 수정 완료',
                            style: const TextStyle(
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
            ]),
          ),
        ),
      ),
    );
  }
}
