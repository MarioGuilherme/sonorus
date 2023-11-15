import "package:intl/intl.dart";

extension TimeAgoExtension on DateTime {
    String get timeAgo {
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(this);

      final int differenceSeconds = difference.inSeconds;
      if (differenceSeconds <= 59)
        return "$differenceSeconds segundo(s) atrás";

      final int differenceMinutes = difference.inMinutes;
      if (differenceMinutes <= 59)
        return "$differenceMinutes minuto(s) atrás";

      final int differenceHours = difference.inHours;
      if (differenceHours <= 23)
        return "$differenceHours hora(s) atrás";

      final int differenceDays = difference.inDays;
      if (differenceDays <= 30)
        return "$differenceDays dia(s) atrás";

      final DateFormat formatter = DateFormat("dd-MM-yyyy");
      return formatter.format(this);
    }
}