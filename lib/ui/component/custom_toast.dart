import 'package:flutter/material.dart';

import '../../utils/colors.dart';

void showCustomToast(BuildContext context, String message) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        width: null,
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              margin: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              decoration: BoxDecoration(
                color: lightGrayColor2, // 배경 색상 설정
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(Icons.star, color: Colors.white), // 아이콘
                  const SizedBox(width: 8),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: "400m",
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(const Duration(seconds: 1), () {
    overlayEntry.remove();
  });
}
