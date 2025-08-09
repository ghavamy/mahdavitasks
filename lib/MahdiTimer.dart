import 'dart:async';
import 'MahdiCalculator.dart';
import 'DigitFlip.dart';
import 'package:flutter/material.dart';

class MahdiTimer extends StatefulWidget {
  const MahdiTimer({super.key});

  @override
  _MahdiTimerState createState() => _MahdiTimerState();
}

class _MahdiTimerState extends State<MahdiTimer> {
  late final Stream<Map<String, int>> breakdownStream;

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

    // Initialize the breakdown stream
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
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      timeBreakdown = MahdiCalculator.getElapsedBreakdown();

      _hoursController.add(timeBreakdown['hours']?.toString().padLeft(2, '0') ?? '00');
      _minutesController.add(timeBreakdown['minutes']?.toString().padLeft(2, '0') ?? '00');
      _secondsController.add(timeBreakdown['seconds']?.toString().padLeft(2, '0') ?? '00');
      _daysController.add(timeBreakdown['days']?.toString().padLeft(2, '0') ?? '00');
      _monthsController.add(timeBreakdown['months']?.toString().padLeft(2, '0') ?? '00');
      _yearsController.add(timeBreakdown['years']?.toString().padLeft(4, '0') ?? '00');
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

  String _toPersianDigits(String number) {
    const digits = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];
    return number.split('').map((d) => digits[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTimeDisplay(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child:Column(
            children: [
              Image.asset(
                'assets/images/mahdi.jpg',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              TextField(
                  decoration: InputDecoration(
                    hintText: '...بسم الله',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  textAlign: TextAlign.right, // for RTL
                  style: TextStyle(fontSize: 16),
                ), 
              SizedBox(height: 10), 
              buildButtonsUnderTextField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the main display for the timer
  Widget buildTimeDisplay(){
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/smooth_green_gradient.png',
            fit: BoxFit.cover,
          ), 
        ),
        Center(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      buildDigitStreamWithLabel(stream: yearsStream, label: "سال"),
                      SizedBox(width: 8),
                      buildDigitStreamWithLabel(stream: monthsStream, label: "ماه"),
                      SizedBox(width: 8),
                      buildDigitStreamWithLabel(stream: daysStream, label: "روز"),
                      SizedBox(width: 8),
                      buildDigitStreamWithLabel(stream: hoursStream, label: "ساعت"),
                      SizedBox(width: 8),
                      buildDigitStreamWithLabel(stream: minutesStream, label: "دقیقه"),
                      SizedBox(width: 8),
                      buildDigitStreamWithLabel(stream: secondsStream, label: "ثانیه"),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ای بهار آرزوها، ای امامِ دلنشین\nبیا که دل شکسته شود ز فراق غمین',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'IranNastaliq',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }

  // Build the digit stream for the flipping digits
  Widget buildDigitStreamWithLabel({
    required Stream<String> stream,
    required String label,
    }) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Vazir',
            ),
          ),
          SizedBox(height: 4),
          StreamBuilder<String>(
            stream: stream,
            builder: (context, snapshot) {
              final digits = (snapshot.data ?? "00").split('');
              final persianDigits = digits.map((d) => _toPersianDigits(d)).toList();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: persianDigits.map((d) => DigitFlip(digit: d)).toList(),
              );
            },
          ),
        ],
      );
  }

  // Build the buttons under the text field
  Widget buildButtonsUnderTextField(){
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: First button action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'دکمه اول',
                    style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Second button action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'دکمه دوم',
                    style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
                  ),
                ),
              ],
            );
  }
}