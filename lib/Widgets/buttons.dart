import 'package:flutter/material.dart';
import 'package:mahdavitasks/DatesWindow/note_store.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditMode = true;
  String _savedText = '';
  String? _currentEntryId;

  @override
  void initState() {
    super.initState();
    // Load today's task after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodayTask();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadTodayTask() async {
    if (!mounted) return;
    
    final store = context.read<NotesStore>();
    await store.loadData();
    
    if (!mounted) return;
    
    final today = DateTime.now();
    final shamsiDate = Jalali.fromDateTime(today);
    final entries = store.entriesOn(shamsiDate.year, shamsiDate.month, shamsiDate.day);
    
    if (entries.isNotEmpty) {
      // Load the most recent entry for today
      final latestEntry = entries.last;
      if (mounted) {
        setState(() {
          _savedText = latestEntry.text;
          _currentEntryId = latestEntry.id;
          _isEditMode = false;
        });
      }
    }
  }

  Future<void> _saveTask() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final store = context.read<NotesStore>();
    final today = DateTime.now();
    
    final entry = NoteEntry(
      date: today,
      text: text,
      id: _isEditMode ? _currentEntryId : null,
    );

    if(_isEditMode  && _currentEntryId != null) {
      await store.update(entry);
    } else {
      await store.add(entry);
    }

    setState(() {
      _savedText = text;
      _currentEntryId = entry.id;
      _isEditMode = false;
    });
    
    _textController.clear();
    _focusNode.unfocus();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'عمل روزانه ثبت شد',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Vazir'),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _enterEditMode() {
    setState(() {
      _isEditMode = true;
      _textController.text = _savedText;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: Color.fromARGB(146, 255, 255, 255),
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Text(
            'اعمال روزانه برای رضایت امام زمان',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        // Text input field with submit button or saved text with edit button
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(146, 255, 255, 255),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                if (_isEditMode) ...[
                  // Edit mode: Show text input with submit button
                  TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'عمل روزانه خود را وارد کنید...',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(
                        fontFamily: 'Vazir',
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(80, 16, 16, 16), // Extra padding on left for button
                    ),
                    maxLines: 1,
                    onSubmitted: (_) => _saveTask(),
                  ),
                  // Submit button positioned at bottom-right
                  Positioned(
                    left: 8,
                    top: 8,
                    bottom: 8,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size(60, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'ثبت',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Display mode: Show saved text with edit button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(80, 16, 16, 16),
                    child: Text(
                      _savedText,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Edit button positioned at bottom-right
                  Positioned(
                    left: 8,
                    top: 8,
                    bottom: 8,
                    child: ElevatedButton(
                      onPressed: _enterEditMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size(60, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'ویرایش',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}