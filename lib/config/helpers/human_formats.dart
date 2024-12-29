import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en',
    ).format(number);

    return formattedNumber;
  }

  static String shortDate(DateTime date) {
    final format = DateFormat.yMMMEd();
    return format.format(date);
  }

  static String today() {
    final format = DateFormat.MMMEd();
    return format.format(DateTime.now());
  }

  static String month(DateTime date) {
    final format = DateFormat.MMMM();
    return format.format(date);
  }

  static String currentMonth() {
    return month(DateTime.now());
  }

  static String year(DateTime date) {
    final format = DateFormat.y();
    return format.format(date);
  }

  static String currentYear() {
    return year(DateTime.now());
  }

  static int howOld(DateTime birthday) {
    final currentDate = DateTime.now();

    int age = currentDate.year - birthday.year;

    if (currentDate.month < birthday.month || (currentDate.month == birthday.month && currentDate.day < birthday.day)) {
      age--;
    }

    return age;
  }
}
