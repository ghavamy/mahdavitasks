import 'dart:async';
import 'dart:ui';
import 'package:mahdavitasks/Widgets/poem_carousel.dart';
import 'Widgets/buttons.dart';
import 'MahdiCalculator.dart';
import 'package:flutter/material.dart';

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
                    _buildDigitStreamWithLabel(stream: yearsStream, label: "سال", progressValue: timeBreakdown['years']! / 10000, ringColor: Color(0xFFEFF4E0), fillColor: Color(0xFFD3BD67)),
                    const SizedBox(width: 20),
                    _buildDigitStreamWithLabel(stream: monthsStream, label: "ماه", progressValue: timeBreakdown['months']! / 12, ringColor: Color(0xFFEFF4E0), fillColor: Color(0xFF7CAC99)),
                    const SizedBox(width: 20),
                    _buildDigitStreamWithLabel(stream: daysStream, label: "روز", progressValue: timeBreakdown['days']! / 30, ringColor: Color(0xFFEFF4E0), fillColor: Color(0xFFABD6D7)),
                    const SizedBox(width: 20),
                    _buildDigitStreamWithLabel(stream: hoursStream, label: "ساعت", progressValue: timeBreakdown['hours']! / 24, ringColor: Color(0xFFEFF4E0), fillColor: Color(0xFF66571D)),
                    const SizedBox(width: 20),
                    _buildDigitStreamWithLabel(stream: minutesStream, label: "دقیقه", progressValue: timeBreakdown['minutes']! / 60, ringColor: Color(0xFFEFF4E0), fillColor: Color.fromARGB(255, 145, 112, 235)),
                    const SizedBox(width: 20),
                    _buildDigitStreamWithLabel(stream: secondsStream, label: "ثانیه", progressValue: timeBreakdown['seconds']! / 60, ringColor: Color(0xFFEFF4E0), fillColor: Color(0xFF2C2C2C)),
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
    required double progressValue, // 0.0 → 1.0
    required Color ringColor,
    required Color fillColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _labelChip(label),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progressValue.clamp(0.0, 1.0),
                strokeWidth: 10,
                backgroundColor: ringColor,
                valueColor: AlwaysStoppedAnimation<Color>(fillColor),
              ),
            ),
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.white.withOpacity(0.08),
                  alignment: Alignment.center,
                  child: StreamBuilder<String>(
                    stream: stream,
                    builder: (context, snapshot) {
                      final text = _toPersianDigits(snapshot.data ?? '00');
                      return Text(
                        text,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Vazir',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _labelChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontFamily: 'Vazir', // or your preferred Persian‑friendly font
        ),
      ),
    );
  }
}