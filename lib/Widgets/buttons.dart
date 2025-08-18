import 'package:flutter/material.dart';
import 'package:mahdavitasks/DatesWindow/note_store.dart';
import 'package:mahdavitasks/DatesWindow/mainDateWindow.dart';
import 'package:mahdavitasks/Widgets/animated_button.dart';
import 'package:provider/provider.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                const Text(
                  'اعمال روزانه برای رضایت امام زمان',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazir',
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Grid of Buttons
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _gridButton(context, 'نذر صلوات'),
              _gridButton(context, 'تلاوت قرآن'),
              _gridButton(context, 'طعام،نذر'),
              _gridButton(context, '...قدمی دیگر'),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade200, Colors.teal.shade700],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Navigation Button
          AnimatedCalendarButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _gridButton(BuildContext context, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFf5f5f5),
        padding: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _showInfoPopup(context, label),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/button_tile.png'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Vazir',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  void _showInfoPopup(BuildContext context, String title) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'اطلاعات تکمیلی برای $title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  hintText: 'اینجا بنویسید...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final store = Provider.of<NotesStore>(context, listen: false);
                  store.add(
                    NoteEntry(
                      date: DateTime.now(),
                      text: textController.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Maindatewindow()),
                  );
                },
                child: const Text('ثبت'),
              ),
            ],
          ),
        );
      },
    );
  }
}