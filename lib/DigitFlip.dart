import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flip_board/flip_widget.dart';



class DigitFlip extends StatefulWidget {
  final String digit;

  const DigitFlip({required this.digit, super.key});

  @override
  _DigitFlipState createState() => _DigitFlipState();
}

class _DigitFlipState extends State<DigitFlip> {
  late StreamController<String> _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<String>();
    _controller.add(widget.digit);
  }

  @override
  void didUpdateWidget(covariant DigitFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _controller.add(widget.digit);
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlipWidget<String>(
      itemStream: _controller.stream,
      initialValue: widget.digit,
      itemBuilder: (_, value) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 59, 59, 57),
          borderRadius: BorderRadius.circular(4),
        ),
        width: 40,
        height: 60,
        child: Text(
          value ?? '',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'Vazir',
          ),
        ),
      ),
      flipType: FlipType.middleFlip,
      flipDirection: AxisDirection.down,
    );
  }
}