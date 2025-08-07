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
  late final StreamController<String> _hoursController;
  late final StreamController<String> _minutesController;
  late final StreamController<String> _secondsController;
  late final Stream<String> hoursStream;
  late final Stream<String> minutesStream;
  late final Stream<String> secondsStream;
  Map<String, int> timeBreakdown = {};

  @override
  void initState() {
    super.initState();

    // Initialize the breakdown stream
    _hoursController = StreamController<String>.broadcast();
    _minutesController = StreamController<String>.broadcast();
    _secondsController = StreamController<String>.broadcast();
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
    });
  }

  @override
  void dispose() {
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
          Image.asset(
            'assets/images/mahdi.jpg',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Card(
              color: const Color.fromARGB(255, 113, 212, 121),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child:Column(
                      children: [
                      Text(
                          '${_toPersianDigits((timeBreakdown['years'] ?? 0).toString())} سال'
                          '${_toPersianDigits((timeBreakdown['months'] ?? 0).toString())} ماه'
                          '${_toPersianDigits((timeBreakdown['days'] ?? 0).toString())}روز',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            fontFamily: 'Vazir', // if you're using a Persian font
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<String>(
                              stream: hoursStream,
                              builder: (context, snapshot) {
                                final digits = (snapshot.data ?? "00").split('');
                                return Row(
                                  children: digits.map((d) => DigitFlip(digit: d)).toList(),
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            StreamBuilder<String>(
                              stream: minutesStream,
                              builder: (context, snapshot) {
                                final digits = (snapshot.data ?? "00").split('');
                                return Row(
                                  children: digits.map((d) => DigitFlip(digit: d)).toList(),
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            StreamBuilder<String>(
                              stream: secondsStream,
                              builder: (context, snapshot) {
                                final digits = (snapshot.data ?? "00").split('');
                                return Row(
                                  children: digits.map((d) => DigitFlip(digit: d)).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child:TextField(
              decoration: InputDecoration(
                hintText: '...بسم الله',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              textAlign: TextAlign.right, // for RTL
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFlippingDigits(int number) {
    String persian = _toPersianDigits(number.toString().padLeft(2, '0'));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: persian.split('').map((digit) {
        return DigitFlip(digit: digit);
      }).toList(),
    );
  }
}