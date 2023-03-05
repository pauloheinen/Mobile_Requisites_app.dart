import 'package:intl/intl.dart';

class DateUtil {
  static const String SYSTEM_DATA_PATTERN = "dd/MMM/yyyy";
  static const String EN_US_DATA_PATTERN = "yyyy/MM/dd";
  static const String SYSTEM_LOCALE_PATTERN = "pt_BR";

  static String higherDate(String initial, String estimated) {
    DateTime dt1 = DateTime.parse(_convertMonthNameToNumber(initial));
    DateTime dt2 = DateTime.parse(_convertMonthNameToNumber(estimated));

    if (dt2.compareTo(dt1) > 0) {
      return "2";
    }
    return "1";
  }

  static _convertMonthNameToNumber(String date) {
    date = date.replaceAll("/", "-");

    var inputFormat = DateFormat("dd-MMM-yyyy", SYSTEM_LOCALE_PATTERN);
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat("yyyy-MM-dd", SYSTEM_LOCALE_PATTERN);
    return outputFormat.format(inputDate);
  }

  static getActualMomentTimestamp() {
    return DateFormat("dd/MMM/yyyy HH:mm", SYSTEM_LOCALE_PATTERN)
        .format(DateTime.now());
  }

  static String formatDateToDDMMMYYYY(DateTime pickedDate) {
    return DateFormat(SYSTEM_DATA_PATTERN, SYSTEM_LOCALE_PATTERN)
        .format(pickedDate);
  }
}
