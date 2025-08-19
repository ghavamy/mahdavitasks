import 'package:flutter/material.dart';
import 'package:mahdavitasks/DatesWindow/note_store.dart';
import 'package:mahdavitasks/DatesWindow/mainDateWindow.dart';
import 'package:mahdavitasks/Widgets/animated_button.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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
              color: Colors.teal.shade50.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'اعمال روزانه برای رضایت امام زمان',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                  color: Colors.black87,
                ),
              ),
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

          // Divider
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

          const SizedBox(height: 24),
          // Animated Calendar Button
          const AnimatedCalendarButton(),
        ],
      ),
    );
  }

  Widget _gridButton(BuildContext context, String label) {
    return GestureDetector(
      onTap: () => _showInfoPopup(context, label),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF007B83), Color(0xFF00C2BA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Glass overlay
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              // Border gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
              // Label
              Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFAF9F6),
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              ),
            ],
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007B83),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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