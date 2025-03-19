import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false ? widget.onChanged(true) : widget.onChanged(false);
          },
          child:
              Container(
            width: 38.0,
            height: 22.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(31.0),
              color: const Color(0xFF387478),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                    width: 16.0,
                    height: 16.0,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: Text(
                      widget.value == true ? 'on' : 'off',
                      style: TextStyle(
                        color: widget.value == true ? const Color(0xFF387478) : const Color(0xFF387478),
                        fontFamily: '400m',
                        fontSize: 12,
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}
