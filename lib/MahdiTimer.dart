import 'dart:async';
import 'package:mahdavitasks/Widgets/poem_carousel.dart';
import 'Widgets/buttons.dart';
import 'MahdiCalculator.dart';
import 'package:flutter/material.dart';
import 'Widgets/circular_time_widget.dart';

class MahdiTimer extends StatefulWidget {
  const MahdiTimer({super.key});

  @override
  _MahdiTimerState createState() => _MahdiTimerState();
}

class _MahdiTimerState extends State<MahdiTimer> {
  late final StreamController<String> _daysController;
  late final StreamController<String> _monthsController;
  late final StreamController<String> _yearsController;
  late final StreamController<String> _hoursController;
  late final StreamController<String> _minutesController;
  late final StreamController<String> _secondsController;

  late final Stream<String> daysStream;
  late final Stream<String> monthsStream;
  late final Stream<String> yearsStream;
  late final Stream<String> hoursStream;
  late final Stream<String> minutesStream;
  late final Stream<String> secondsStream;

  Map<String, int> timeBreakdown = {};

  final Color _chipBg = const Color(0xFFEFF4E0); // light olive-tinted chip
  final Color _divider = const Color(0xFFDEE3D3);

  @override
  void initState() {
    super.initState();

    _daysController = StreamController<String>.broadcast();
    _monthsController = StreamController<String>.broadcast();
    _yearsController = StreamController<String>.broadcast();
    _hoursController = StreamController<String>.broadcast();
    _minutesController = StreamController<String>.broadcast();
    _secondsController = StreamController<String>.broadcast();

    daysStream = _daysController.stream;
    monthsStream = _monthsController.stream;
    yearsStream = _yearsController.stream;
    hoursStream = _hoursController.stream;
    minutesStream = _minutesController.stream;
    secondsStream = _secondsController.stream;

    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      timeBreakdown = MahdiCalculator.getElapsedBreakdown();

      _hoursController.add(timeBreakdown['hours']?.toString().padLeft(2, '0') ?? '00');
      _minutesController.add(timeBreakdown['minutes']?.toString().padLeft(2, '0') ?? '00');
      _secondsController.add(timeBreakdown['seconds']?.toString().padLeft(2, '0') ?? '00');
      _daysController.add(timeBreakdown['days']?.toString().padLeft(2, '0') ?? '00');
      _monthsController.add(timeBreakdown['months']?.toString().padLeft(2, '0') ?? '00');
      _yearsController.add(timeBreakdown['years']?.toString().padLeft(4, '0') ?? '0000');
    });
  }

  @override
  void dispose() {
    _daysController.close();
    _monthsController.close();
    _yearsController.close();
    _hoursController.close();
    _minutesController.close();
    _secondsController.close();
    super.dispose();
  }

  // Safe Persian digit mapping (ignores non-digits gracefully)
  String _toPersianDigits(String input) {
    const fa = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];
    final buffer = StringBuffer();
    for (final ch in input.characters) {
      if (ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57) {
        buffer.write(fa[int.parse(ch)]);
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTimeDisplay(),
              const PoemCarousel(),
              const SizedBox(height: 14),
              Buttons(),
            ],
          ),
        ),
      ),
    );
  }

  // Build the main display for the timer
  Widget buildTimeDisplay() {
    return Center(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 20),
          child: Column(
            children: [
              // Time rows
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDigitStreamWithLabel(stream: yearsStream, label: "سال", progressValue: timeBreakdown['years']! / 60, circleBackgroundColor: Color(0xFFD3BD67)),
                    const SizedBox(width: 10),
                    _buildDigitStreamWithLabel(stream: monthsStream, label: "ماه", progressValue: timeBreakdown['months']! / 60, circleBackgroundColor: Color(0xFF7CAC99)),
                    const SizedBox(width: 10),
                    _buildDigitStreamWithLabel(stream: daysStream, label: "روز", progressValue: timeBreakdown['days']! / 60, circleBackgroundColor: Color(0xFFABD6D7)),
                    const SizedBox(width: 10),
                    _buildDigitStreamWithLabel(stream: hoursStream, label: "ساعت", progressValue: timeBreakdown['hours']! / 60, circleBackgroundColor: Color(0xFF66571D)),
                    const SizedBox(width: 10),
                    _buildDigitStreamWithLabel(stream: minutesStream, label: "دقیقه", progressValue: timeBreakdown['minutes']! / 60, circleBackgroundColor: Color(0xFFFFFFFF)),
                    const SizedBox(width: 10),
                    _buildDigitStreamWithLabel(stream: secondsStream, label: "ثانیه", progressValue: timeBreakdown['seconds']! / 60, circleBackgroundColor: Color(0xFF2C2C2C)),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      );
    }

  Widget _buildDigitStreamWithLabel({
      required Stream<String> stream,
      required String label,
      required double progressValue, // 0.0 to 1.0
      required Color circleBackgroundColor, // new parameter
    }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _divider),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              fontFamily: 'Vazir',
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Circular arc + digits
        CircularTimeDisplay(
          seconds: (progressValue * 60).toInt(),
          size: 120,
          backgroundColor: circleBackgroundColor, // your custom color
          progressColor: Colors.black, // always black arc
          centerContent: StreamBuilder<String>(
            stream: stream,
            builder: (context, snapshot) {
              final text = snapshot.data ?? "00";
              final persianText = _toPersianDigits(text);
              return Text(
                persianText,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Vazir',
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ],
    );
  }
}