import 'package:flutter/material.dart';

import '../../utils/colors.dart';

Future<void> showSecessionCenterPopup(BuildContext context, {Function? onConfirmTapFunc, Function? onCancelTapFunc}) async {
  centerPopUpWidget(
    context,
    "탈퇴 하시면 일정이 모두 삭제돼요.\n정말 탈퇴 하시겠어요?",
    "",
    "확인",
    "취소",
    true,
    confirmButtonTextTapFunction: onConfirmTapFunc ?? () async {},
    cancelButtonTextTapFunction: onCancelTapFunc ?? () async {},
  );
}

void centerPopUpWidget(
  BuildContext context,
  String title,
  String subTitle,
  String buttonText,
  String cancelText,
  bool canCancel, {
  required Function confirmButtonTextTapFunction,
  required Function cancelButtonTextTapFunction,
  TextAlign titleTextAlign = TextAlign.center,
  TextAlign subTitleTextAlign = TextAlign.center,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(
            maxWidth: 310,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            top: 30,
            right: 25,
            left: 25,
            bottom: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 150,
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        title.isNotEmpty
                            ? Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.45, // lineHeight
                                  color: Colors.black,
                                  fontFamily: "500b",
                                ),
                                textAlign: titleTextAlign,
                              )
                            : Container(),
                        subTitle.isNotEmpty
                            ? Text(
                                subTitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.45, // lineHeight
                                  color: lightGrayColor,
                                  fontFamily: "400m",
                                ),
                                textAlign: titleTextAlign,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  canCancel
                      ? Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              Navigator.pop(context);
                              await cancelButtonTextTapFunction();
                            },
                            child: Container(
                                constraints: const BoxConstraints(maxHeight: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: lightGrayColor2,
                                    width: 1, // 테두리 두께
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    cancelText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.45, // lineHeight
                                      color: Colors.black,
                                      fontFamily: "400m",
                                    ),
                                  ),
                                )),
                          ),
                        )
                      : Container(),
                  SizedBox(width: canCancel ? 10 : 0),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        Navigator.pop(context);
                        await confirmButtonTextTapFunction();
                      },
                      child: Container(
                          constraints: const BoxConstraints(maxHeight: 50), //높이를 제한
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.45, // lineHeight
                                color: Colors.white,
                                fontFamily: "400m",
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
