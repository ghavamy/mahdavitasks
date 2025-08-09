import 'package:flutter/material.dart';

class DualButtonWidget extends StatefulWidget {
  @override
  _DualButtonWidgetState createState() => _DualButtonWidgetState();
}

class _DualButtonWidgetState extends State<DualButtonWidget> {
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isSubmitted
          ? ElevatedButton(
              onPressed: () {
                // Action for SHOW
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.green,
              ),
              child: Text("نشان"),
            )
          : ElevatedButton(
              onPressed: () {
                // Action for SUBMIT
                setState(() {
                  isSubmitted = true;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text("ثبت"),
            ),
    );
  }
}