import 'package:intl/intl.dart';

String formatDateWithDayName(DateTime date, {bool showCompleteDay = true}) {
  if (showCompleteDay) {
    return DateFormat("EEEE, d/ MMM/ yyyy").format(date);
  } else {
    return DateFormat("EEE, d/ MMM/ yyyy").format(date);
  }
}
