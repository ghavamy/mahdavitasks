// persian_utils.dart
import 'package:shamsi_date/shamsi_date.dart';

class PersianUtils {
  // Persian month names (Jalali order)
  static const List<String> monthsFa = [
    'فروردین', 'اردیبهشت', 'خرداد',
    'تیر', 'مرداد', 'شهریور',
    'مهر', 'آبان', 'آذر',
    'دی', 'بهمن', 'اسفند',
  ];

  /// Convert any Western digits in [input] to Persian numerals
  static String toPersianDigits(String input) {
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const fa = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];

    var out = input;
    for (int i = 0; i < en.length; i++) {
      out = out.replaceAll(en[i], fa[i]);
    }
    return out;
  }

  /// Get Persian month name for given [month] (1–12)
  static String monthName(int month) {
    if (month < 1 || month > 12) return '';
    return monthsFa[month - 1];
  }

  static String dayOrdinal(int day) {
    const ordinals = [
      '', // index 0 unused
      'اول', 'دوم', 'سوم', 'چهارم', 'پنجم', 'ششم', 'هفتم', 'هشتم', 'نهم', 'دهم',
      'یازدهم', 'دوازدهم', 'سیزدهم', 'چهاردهم', 'پانزدهم', 'شانزدهم', 'هفدهم', 'هجدهم', 'نوزدهم', 'بیستم',
      'بیست و یکم', 'بیست و دوم', 'بیست و سوم', 'بیست و چهارم', 'بیست و پنجم', 'بیست و ششم', 'بیست و هفتم', 'بیست و هشتم', 'بیست و نهم', 'سی‌ام',
      'سی و یکم'
    ];
    if (day < 1 || day > 31) return '';
    return ordinals[day];
  }


  /// Get Persian weekday name for given [weekDay] (1–7)
  static String weekdayName(int weekDay) {
    const weekdaysFa = [
      'شنبه',     // 1
      'یک‌شنبه',  // 2
      'دو‌شنبه',  // 3
      'سه‌شنبه',  // 4
      'چهار‌شنبه',// 5
      'پنج‌شنبه', // 6
      'جمعه',     // 7
    ];
    if (weekDay < 1 || weekDay > 7) return '';
    return weekdaysFa[weekDay - 1];
  }

  static String formatJalaliDate(Jalali date) {
    final weekday = weekdayName(date.weekDay);
    final day = toPersianDigits(date.day.toString());
    final month = monthName(date.month);
    return '$weekday، $day $month';
  }

  static String hijriMonthNameArabic(int month) {
    const arabicMonths = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب',
      'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    if (month < 1 || month > 12) return '';
    return arabicMonths[month - 1];
  }
}