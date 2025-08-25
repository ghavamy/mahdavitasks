import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';

class MonthCalendarWidget extends StatefulWidget {
  final int year;
  final int month;
  final Function(int day)? onDateSelected;
  final int? selectedDay;

  const MonthCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    this.onDateSelected,
    this.selectedDay,
  });

  @override
  State<MonthCalendarWidget> createState() => _MonthCalendarWidgetState();
}

class _MonthCalendarWidgetState extends State<MonthCalendarWidget> {
  // Persian weekday names starting from Saturday (Jalali week starts on Saturday)
  static const List<String> weekdayNames = [
    'ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'
  ];

  @override
  Widget build(BuildContext context) {
    final jalaliDate = Jalali(widget.year, widget.month, 1);
    final daysInMonth = jalaliDate.monthLength;
    
    // Get the weekday of the first day of the month (1 = Saturday, 7 = Friday)
    final firstDayWeekday = jalaliDate.weekDay;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month and year header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '${PersianUtils.monthName(widget.month)} ${PersianUtils.toPersianDigits(widget.year.toString())}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Calendar table
          Table(
            children: [
              // Weekday headers
              TableRow(
                children: weekdayNames.map((day) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )).toList(),
              ),
              
              // Calendar days
              ..._buildCalendarRows(daysInMonth, firstDayWeekday),
            ],
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildCalendarRows(int daysInMonth, int firstDayWeekday) {
    final List<TableRow> rows = [];
    final List<Widget> currentWeek = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstDayWeekday; i++) {
      currentWeek.add(const SizedBox(height: 40));
    }
    
    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = widget.selectedDay == day;
      
      currentWeek.add(
        GestureDetector(
          onTap: () => widget.onDateSelected?.call(day),
          child: Container(
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected 
                  ? null 
                  : Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
            ),
            child: Center(
              child: Text(
                PersianUtils.toPersianDigits(day.toString()),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
      
      // If we've filled a week (7 days) or reached the end, create a row
      if (currentWeek.length == 7) {
        rows.add(TableRow(children: List.from(currentWeek)));
        currentWeek.clear();
      }
    }
    
    // Fill remaining cells in the last week if needed
    while (currentWeek.isNotEmpty && currentWeek.length < 7) {
      currentWeek.add(const SizedBox(height: 40));
    }
    
    if (currentWeek.isNotEmpty) {
      rows.add(TableRow(children: currentWeek));
    }
    
    return rows;
  }
}