import 'package:flutter/material.dart';
import '../DatesWindow/note_store.dart';
import 'package:provider/provider.dart';
import 'package:mahdavitasks/DatesWindow/mainDateWindow.dart';

class DualButtonWidget extends StatefulWidget {
  const DualButtonWidget({super.key});

  @override
  _DualButtonWidgetState createState() => _DualButtonWidgetState();
}

class _DualButtonWidgetState extends State<DualButtonWidget> {
  bool isSubmitted = false;
  String submittedText = "";
  TextEditingController controller = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label + Field or Submitted Text
        SizedBox(
            height: 120,
            child: isSubmitted
              ? Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.85),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          submittedText,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSubmitted = false;
                          });

                          // Delay slightly to allow rebuild, then request focus
                          Future.delayed(Duration(milliseconds: 100), () {
                            textFieldFocus.requestFocus();
                          });
                        },
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                )
                : TextField(
                    controller: controller,
                    focusNode: textFieldFocus,
                    textAlign: TextAlign.right,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '...بسم الله',
                      filled: true,
                      fillColor: Color.fromRGBO(255, 255, 255, 0.85),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        SizedBox(height: 12),

        // Buttons
        isSubmitted
            ? ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Maindatewindow(), // ← define this screen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text("نمایش"),
              )
            : ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    context.read<NotesStore>().add(NoteEntry(
                      date: DateTime.now(),
                      text: controller.text.trim(),
                    ));
                    setState(() {
                      submittedText = controller.text.trim();
                      isSubmitted = true;
                    });
                  } else {
                    // Optional: Show a message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "لطفاً یک متن وارد کنید",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text("ارسال"),
              ),
      ],
    );
  }
}