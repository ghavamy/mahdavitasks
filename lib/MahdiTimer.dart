import 'dart:async';
import 'Widgets/buttons.dart';
import 'MahdiCalculator.dart';
import 'Widgets/DigitFlip.dart';
import 'package:flutter/material.dart';
import 'Widgets/DualButtonWidget.dart';

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

  // Palette accents (gentle, handcrafted vibe)
  final Color _accentOlive = const Color(0xFFBFD34D);
  final Color _paperWhite = const Color(0xFFFFFFFF);
  final Color _paperTint = const Color(0xFFF7F9F2);
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
              const SizedBox(height: 28),
              _buildDevotionalSection(),
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
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          image: DecorationImage(
            image: AssetImage('assets/images/IslamicButton.png'), 
            fit: BoxFit.cover,
            alignment: Alignment.center
          ),
          border: Border.all(color: Colors.black.withOpacity(0.03)),
        ),
        child: Column(
          children: [
            // Time rows (with a divider between date and time parts)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDigitStreamWithLabel(stream: yearsStream, label: "سال"),
                  const SizedBox(width: 10),
                  _buildDigitStreamWithLabel(stream: monthsStream, label: "ماه"),
                  const SizedBox(width: 10),
                  _buildDigitStreamWithLabel(stream: daysStream, label: "روز"),
                  const SizedBox(width: 16),
                  Container(width: 1, height: 52, color: _divider),
                  const SizedBox(width: 16),
                  _buildDigitStreamWithLabel(stream: hoursStream, label: "ساعت"),
                  const SizedBox(width: 10),
                  _buildDigitStreamWithLabel(stream: minutesStream, label: "دقیقه"),
                  const SizedBox(width: 10),
                  _buildDigitStreamWithLabel(stream: secondsStream, label: "ثانیه"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Poem nicely framed
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(192, 250, 250, 250),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.04)),
              ),
              child: const Text(
                'ای بهار آرزوها، ای امامِ دلنشین\nبیا که دل شکسته شود ز فراق غمین',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'IranNastaliq',
                  color: Colors.black,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Label chip + flipping digits
  Widget _buildDigitStreamWithLabel({
    required Stream<String> stream,
    required String label,
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
        // Digits
        StreamBuilder<String>(
          stream: stream,
          builder: (context, snapshot) {
            final text = snapshot.data ?? "00";
            final digits = text.split('');
            final persianDigits = digits.map(_toPersianDigits).toList();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final d in persianDigits) ...[
                  DigitFlip(digit: d),
                  const SizedBox(width: 2),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDevotionalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered devotional chip
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _accentOlive,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "برای امام زمان (عج)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Buttons(),
        ],
      ),
    );
  }
}