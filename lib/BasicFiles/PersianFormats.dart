// persian_utils.dart
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

}