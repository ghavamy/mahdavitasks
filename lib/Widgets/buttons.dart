import 'package:flutter/material.dart';
import 'package:mahdavitasks/DatesWindow/note_store.dart';
import 'package:mahdavitasks/DatesWindow/mainDateWindow.dart';
import 'package:provider/provider.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 2.0,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _gridButton(context, 'نذر صلوات'),
              _gridButton(context, 'تلاوت قرآن'),
              _gridButton(context, 'طعام،نذر'),
              _gridButton(context, '...قدمی دیگر'),
            ],
          ),
          const SizedBox(height: 16),
          // Navigation button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Maindatewindow()),
            );
          },
          
          child: const Text(
            'رفتن به تقویم',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _gridButton(BuildContext context, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // gentle curve
        ),
        padding: EdgeInsets.zero,
        minimumSize: const Size(80, 80),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
      ),
      onPressed: () {
        _showInfoPopup(context, label);
      },
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontWeight: FontWeight.bold,
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
                      text: textController.text.trim(), // or whatever TextEditingController you use
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