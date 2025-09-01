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

  @override
  void initState() {
    super.initState();
    // Initialize with current Jalali date using shamsi_date package
    final now = DateTime.now();
    final jalaliNow = Jalali.fromDateTime(now);
    selectedYear = jalaliNow.year;
    selectedMonth = jalaliNow.month;
    selectedDay = jalaliNow.day; // Optional: start with today selected
  }

  // Decide the top bar color based on Jalali month number (1–12)
  Color _seasonColor(BuildContext context, int month) {
    if (month >= 1 && month <= 3) {
      return Theme.of(context).colorScheme.tertiary; // Spring
    } else if (month >= 4 && month <= 6) {
      return Theme.of(context).colorScheme.secondary; // Summer
    } else if (month >= 7 && month <= 9) {
      return Theme.of(context).colorScheme.primary; // Autumn
    } else {
      return Theme.of(context).colorScheme.primaryContainer; // Winter
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
        title: const Text('تقویم اعمال'),
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
          ),
        ),
      ),
      body: Column(
        children: [
          // Calendar widget
          Padding(
            padding: const EdgeInsets.all(16.0),
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
          
          // Tasks for selected date
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
    );
  }

  Widget _buildTasksForSelectedDate(NotesStore store, int day) {
    final notes = store.entriesOn(selectedYear, selectedMonth, day);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selected date header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: Text(
            'اعمال روز ${PersianUtils.dayOrdinal(day)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        
        // Tasks list
        Expanded(
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
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          note.text,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}