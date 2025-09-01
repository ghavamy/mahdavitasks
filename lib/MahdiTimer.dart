import 'dart:async';
import 'dart:ui';
import 'package:mahdavitasks/DatesWindow/mainDateWindow.dart';
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
    return
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Maindatewindow()),
                );
              },
              tooltip: 'کارنامه اعمال',
              icon: const Icon(Icons.calendar_month),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
                tooltip: 'راهنما',
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                children: [
                  buildTimeDisplay(),
                  const PoemCarousel(),
                  const SizedBox(height: 12),
                  const Buttons(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
  }

  // Build the main display for the timer - always in one row
  Widget buildTimeDisplay() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Column(
        children: [
          // Single row layout for all screen sizes as requested
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDigitStreamWithLabel(
                  stream: yearsStream, 
                  label: "سال", 
                  progressValue: timeBreakdown['years']! / 10000, 
                  ringColor: Theme.of(context).colorScheme.primary.withOpacity(0.6), 
                  fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  size: 120,
                ),
                const SizedBox(width: 8),
                _buildDigitStreamWithLabel(
                  stream: monthsStream, 
                  label: "ماه", 
                  progressValue: timeBreakdown['months']! / 12, 
                  ringColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2), 
                  fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  size: 120,
                ),
                const SizedBox(width: 8),
                _buildDigitStreamWithLabel(
                  stream: daysStream, 
                  label: "روز", 
                  progressValue: timeBreakdown['days']! / 31, 
                  ringColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.2), 
                  fillColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
                  size: 120,
                ),
                const SizedBox(width: 8),
                _buildDigitStreamWithLabel(
                  stream: hoursStream, 
                  label: "ساعت", 
                  progressValue: timeBreakdown['hours']! / 24, 
                  ringColor: Theme.of(context).colorScheme.primary.withOpacity(0.2), 
                  fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  size: 120,
                ),
                const SizedBox(width: 8),
                _buildDigitStreamWithLabel(
                  stream: minutesStream, 
                  label: "دقیقه", 
                  progressValue: timeBreakdown['minutes']! / 60, 
                  ringColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2), 
                  fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  size: 120,
                ),
                const SizedBox(width: 8),
                _buildDigitStreamWithLabel(
                  stream: secondsStream, 
                  label: "ثانیه", 
                  progressValue: timeBreakdown['seconds']! / 60, 
                  ringColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2), 
                  fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  size: 120,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitStreamWithLabel({
    required Stream<String> stream,
    required String label,
    required double progressValue, // 0.0 → 1.0
    required Color ringColor,
    required Color fillColor,
    double size = 200, // Default size, can be overridden for responsive design
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
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progressValue.clamp(0.0, 1.0),
                strokeWidth: size * 0.05, // Proportional stroke width
                backgroundColor: ringColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent.withOpacity(0.9)),
              ),
            ),
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: fillColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: StreamBuilder<String>(
                    stream: stream,
                    builder: (context, snapshot) {
                      final text = _toPersianDigits(snapshot.data ?? '00');
                      return Text(
                        text,
                        style: TextStyle(
                          fontSize: size * 0.16, // Proportional font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // High contrast for light background
                          fontFamily: 'Vazir',
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ],
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87, // High contrast for light background
          fontFamily: 'Vazir',
        ),
      ),
    );
  }
}