import 'package:flutter/material.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';

class CalendarDayCell extends StatelessWidget {
  final int jalaliDay;
  final int gregorianDay;
  final int lunarDay;
  final bool isSelected;
  final bool hasTasks;
  final bool? allDone; // ✅ null if no tasks, true if all done, false if not all done
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.jalaliDay,
    required this.gregorianDay,
    required this.lunarDay,
    required this.isSelected,
    required this.hasTasks,
    required this.onTap,
    this.allDone,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final outlineColor = Theme.of(context).colorScheme.outline;

    // Decide dot color
    Color? dotColor;
    if (hasTasks) {
      dotColor = (allDone ?? false) ? Colors.green : Colors.red;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? null
              : Border.all(color: outlineColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            // Jalali day (center)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    PersianUtils.toPersianDigits(jalaliDay.toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (dotColor != null)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),

            // Gregorian (bottom-left)
            Positioned(
              bottom: 2,
              left: 4,
              child: Text(
                gregorianDay.toString(),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ),

            // Hijri (bottom-right)
            Positioned(
              bottom: 2,
              right: 4,
              child: Text(
                PersianUtils.toPersianDigits(lunarDay.toString()),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}