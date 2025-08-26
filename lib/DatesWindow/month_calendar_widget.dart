import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'package:mahdavitasks/DatesWindow/note_store.dart';
import 'package:mahdavitasks/DatesWindow/date_converters.dart';
import 'package:mahdavitasks/DatesWindow/calendar_day_cell.dart';
import 'package:mahdavitasks/DatesWindow/month_selector_dialog.dart';
import 'package:mahdavitasks/DatesWindow/year_selector_dialog.dart';

class MonthCalendarWidget extends StatefulWidget {
  final Function(int day, int month, int year)? onDateSelected;

  const MonthCalendarWidget({super.key, this.onDateSelected});

  @override
  State<MonthCalendarWidget> createState() => _MonthCalendarWidgetState();
}

class _MonthCalendarWidgetState extends State<MonthCalendarWidget> {
  static const List<String> weekdayNames = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

  late int currentYear;
  late int currentMonth;
  int? selectedDay;

  String _formattedSelectedDate() {
  final date = Jalali(currentYear, currentMonth, selectedDay!);
  final weekday = PersianUtils.weekdayName(date.weekDay); // e.g. "سه‌شنبه"
  final day = PersianUtils.toPersianDigits(date.day.toString());
  final month = PersianUtils.monthName(date.month);
  return '$weekday، $day $month';
}

  @override
  void initState() {
    super.initState();
    final today = Jalali.now();
    currentYear = today.year;
    currentMonth = today.month;
    selectedDay = today.day; // auto-focus today
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NotesStore>();

    final jalaliDate = Jalali(currentYear, currentMonth, 1);
    final daysInMonth = jalaliDate.monthLength;
    final firstDayWeekday = jalaliDate.weekDay; // 1=Sat ... 7=Fri

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
          if (selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔵 Left side: Gregorian & Hijri
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateConverters.formatGregorianDate(
                          DateConverters.jalaliToGregorian(currentYear, currentMonth, selectedDay!),
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontSize: 11,
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                            DateConverters.formatHijriDate(
                              DateConverters.gregorianToHijri(
                                DateConverters.jalaliToGregorian(currentYear, currentMonth, selectedDay!),
                              ),
                          ),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 🟦 Right side: Jalali Month/Year + Weekday/Day
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final y = await showYearSelectorDialog(context);
                              if (y != null && y != currentYear) {
                                setState(() {
                                  currentYear = y;
                                  selectedDay = null;
                                });
                              }
                            },
                            child: Text(
                              PersianUtils.toPersianDigits(currentYear.toString()),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () async {
                              final m = await showMonthSelectorDialog(context);
                              if (m != null && m != currentMonth) {
                                setState(() {
                                  currentMonth = m;
                                  selectedDay = null;
                                });
                              }
                            },
                            child: Text(
                              PersianUtils.monthName(currentMonth),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        PersianUtils.formatJalaliDate(
                          Jalali(currentYear, currentMonth, selectedDay!),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Table(
              children: [
                TableRow(
                  children: weekdayNames
                      .map(
                        (day) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                ..._buildCalendarRows(
                  store: store,
                  daysInMonth: daysInMonth,
                  firstDayWeekday: firstDayWeekday,
                ),
              ],
            ),
          ),
          ],
        ),
      );
  }

  List<TableRow> _buildCalendarRows({
    required NotesStore store,
    required int daysInMonth,
    required int firstDayWeekday,
  }) {
    final List<TableRow> rows = [];
    final List<Widget> currentWeek = [];

    // Empty cells before the first day (works with RTL Table)
    for (int i = 1; i < firstDayWeekday; i++) {
      currentWeek.add(const SizedBox(height: 60));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = selectedDay == day;

      // Build date trio
      final gregorian = DateConverters.jalaliToGregorian(
        currentYear,
        currentMonth,
        day,
      );
      final hijri = DateConverters.gregorianToHijri(gregorian);

      // Task presence (Jalali-based store)
      final hasTasks =
          store.entriesOn(currentYear, currentMonth, day).isNotEmpty;

      currentWeek.add(
        CalendarDayCell(
          jalaliDay: day,
          gregorianDay: gregorian.day,
          lunarDay: hijri.hDay,
          isSelected: isSelected,
          hasTasks: hasTasks,
          onTap: () {
            setState(() {
              selectedDay = day;
            });
            widget.onDateSelected?.call(day, currentMonth, currentYear);
          },
        ),
      );

      if (currentWeek.length == 7) {
        rows.add(TableRow(children: List.from(currentWeek)));
        currentWeek.clear();
      }
    }

    // Fill remaining cells of the last week
    while (currentWeek.isNotEmpty && currentWeek.length < 7) {
      currentWeek.add(const SizedBox(height: 60));
    }
    if (currentWeek.isNotEmpty) {
      rows.add(TableRow(children: List.from(currentWeek)));
    }

    return rows;
  }
}
