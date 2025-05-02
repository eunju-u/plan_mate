import 'package:flutter/material.dart';

class ArrowCell extends StatelessWidget {
  final String title;
  final Function onTap;

  const ArrowCell({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        onTap();
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 20,
          bottom: 20
        ),
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft, // Text 수직 중앙 정렬
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2, // 높이 조정
                    color: Colors.black,
                    fontFamily: "400m",
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
