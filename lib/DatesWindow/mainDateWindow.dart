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
    
    // Always show calendar view with month/year selectors at top
    return _buildCalendarView(store);
  }



  Widget _buildCalendarView(NotesStore store) {
    final years = store.years;
    final months = List<int>.generate(12, (i) => i + 1);
    
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
          // Month and Year selectors at the top
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Year selector
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedYear,
                        isExpanded: true,
                        items: years.map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(
                              PersianUtils.toPersianDigits(year.toString()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'Vazir'),
                            ),
                          );
                        }).toList(),
                        onChanged: (newYear) {
                          if (newYear != null) {
                            setState(() {
                              selectedYear = newYear;
                              // Reset month if it doesn't exist in new year
                              final newMonths = store.monthsIn(newYear);
                              if (!newMonths.contains(selectedMonth)) {
                                selectedMonth = newMonths.first;
                              }
                              selectedDay = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Month selector
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedMonth,
                        isExpanded: true,
                        items: months.map((month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text(
                              PersianUtils.monthName(month),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'Vazir'),
                            ),
                          );
                        }).toList(),
                        onChanged: (newMonth) {
                          if (newMonth != null) {
                            setState(() {
                              selectedMonth = newMonth;
                              selectedDay = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MonthCalendarWidget(
              year: selectedYear,
              month: selectedMonth,
              selectedDay: selectedDay,
              onDateSelected: (day) {
                setState(() {
                  selectedDay = day;
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