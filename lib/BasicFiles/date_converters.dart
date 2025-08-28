import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:hijri/hijri_calendar.dart';

class DateConverters {
  static DateTime jalaliToGregorian(int year, int month, int day) {
    return Jalali(year, month, day).toDateTime();
  }

  static HijriCalendar gregorianToHijri(DateTime date) {
    return HijriCalendar.fromDate(date);
  }

  static String formatGregorianDate(DateTime date) {
    final day = date.day;
    final monthName = _monthNameEn(date.month); // e.g. "August"
    final year = date.year;
    return '$day $monthName $year';
  }

  static String _monthNameEn(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  static String formatHijriDate(HijriCalendar hijri) {
    final day = PersianUtils.toPersianDigits(hijri.hDay.toString());
    final month = PersianUtils.hijriMonthNameArabic(hijri.hMonth);
    final year = PersianUtils.toPersianDigits(hijri.hYear.toString());
    return '$day $month $year';
  }
}
