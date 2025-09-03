import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'package:mahdavitasks/Widgets/month_calendar_widget.dart';
import 'note_store.dart';

class Maindatewindow extends StatefulWidget {
  const Maindatewindow({super.key});

  @override
  State<Maindatewindow> createState() => _MaindatewindowState();
}

class _MaindatewindowState extends State<Maindatewindow> {
  late int selectedYear;
  late int selectedMonth;
  int? selectedDay;

  final Map<String, bool?> _taskStatus = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final jalaliNow = Jalali.fromDateTime(now);
    selectedYear = jalaliNow.year;
    selectedMonth = jalaliNow.month;
    selectedDay = jalaliNow.day;
  }

  Color _seasonColor(BuildContext context, int month) {
    if (month >= 1 && month <= 3) {
      return Theme.of(context).colorScheme.tertiary;
    } else if (month >= 4 && month <= 6) {
      return Theme.of(context).colorScheme.secondary;
    } else if (month >= 7 && month <= 9) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NotesStore>();
    return Scaffold(
      body: SafeArea(
        child: _buildCalendarView(store),
      ),
    );
  }

  Widget _buildCalendarView(NotesStore store) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📿 تقویم اعمال',
          style: TextStyle(
            fontFamily: 'Vazir',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _seasonColor(context, selectedMonth),
                _seasonColor(context, selectedMonth).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/islamic_pattern.png'), // 🔹 Add your pattern image
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFc6a984), // soft golden-brown
              const Color(0xFFe2d1c3), // warm beige
              const Color(0xFFfdfcfb), // light cream
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/tile_bg.png'),
                    fit: BoxFit.cover,
                    opacity: 1.0,
                  ),
                ),

                child: MonthCalendarWidget(
                  onDateSelected: (day, month, year) {
                    setState(() {
                      selectedDay = day;
                      selectedMonth = month;
                      selectedYear = year;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: selectedDay != null
                ? _buildTasksForSelectedDate(store, selectedDay!)
                : const Center(
                    child: Text(
                      'روزی را از تقویم انتخاب کنید',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Vazir',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksForSelectedDate(NotesStore store, int day) {
    final notes = store.entriesOn(selectedYear, selectedMonth, day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔹 Guide row (tasbih style)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 10, color: Colors.red),
            const SizedBox(width: 4),
            const Text('اعمال انجام نشده', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Icon(Icons.circle, size: 10, color: Colors.green),
            const SizedBox(width: 4),
            const Text('همه اعمال انجام شده', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),

        // Selected date header with Quranic border
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade100, Colors.amber.shade50],
            ),
            border: Border.all(color: Colors.amber.shade700, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'اعمال روز ${PersianUtils.dayOrdinal(day)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
            textAlign: TextAlign.center,
          ),
        ),

        // Tasks list
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: notes.isEmpty
                ? const Center(
                    child: Text(
                      'هیچ عملی برای این روز ثبت نشده است',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final status = note.status;

                      Color bgColor;
                      if (status == true) {
                        bgColor = Colors.green.shade100;
                      } else if (status == false) {
                        bgColor = Colors.red.shade100;
                      } else {
                        bgColor = Colors.white;
                      }

                      return Card(
                        color: bgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: status == true
                                ? Colors.green.shade700
                                : status == false
                                    ? Colors.red.shade700
                                    : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 18, 16),
                              child: Text(
                                note.text,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            if (status == null)
                              Positioned(
                                left: 4,
                                bottom: 4,
                                child: Row(
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () => store.updateStatus(
                                          note.id, true),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () => store.updateStatus(
                                          note.id, false),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}