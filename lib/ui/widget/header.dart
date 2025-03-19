import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final bool back;
  final bool close;

  const Header({super.key, required this.back, required this.close});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String menuName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 50,
      ),
      margin: const EdgeInsets.only(),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.back
                    ? InkWell(
                        onTap: () {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 25,
                          width: 25,
                          child: const Icon(Icons.arrow_back),
                        ),
                      )
                    : Container(),
                widget.close
                    ? InkWell(
                        onTap: () {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 25,
                          width: 25,
                          child: const Icon(Icons.close),
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
