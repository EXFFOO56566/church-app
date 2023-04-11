import 'package:intl/intl.dart';

class TimUtil {
  static String timeAgo(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' day';
      } else {
        time = diff.inDays.toString() + ' days';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' wk';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' weeks';
      }
    }

    return time;
  }

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static String timeAgoSinceDate(int timestamp, {bool numericDates = true}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} yrs';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 yr' : 'Last yr';
    } else if ((difference.inDays / 30).floor() >= 2 ||
        (difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} wks';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 wk' : 'Last wk';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hrs';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hr' : 'An hour';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} mins';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 min' : 'A minute';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} scnds';
    } else {
      return 'Just now';
    }
  }

  static bool verifyIfScreenShouldReloadData(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final date2 = DateTime.now();
    final difference = date2.difference(date);
    print("diff in minutes " + difference.inMinutes.toString());
    if (difference.inMinutes > 10) {
      return true;
    } else {
      return false;
    }
  }

  static String timeFormatter(int time) {
    Duration duration = Duration(milliseconds: time.round());

    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  static String prettyDuration(Duration duration) {
    String seconds;
    final minutes = duration.inMinutes.remainder(60);
    final sec = duration.inSeconds.remainder(60);
    if (sec < 10)
      seconds = '0$sec';
    else
      seconds = '$sec';
    return '$minutes:$seconds';
  }

  static String stringForSeconds(double seconds) {
    if (seconds == null || seconds == 0) return "00:00";
    return '${(seconds ~/ 60)}:${(seconds.truncate() % 60).toString().padLeft(2, '0')}';
  }

  String format(int secs) {
    int sec = secs;

    int min = 0;
    if (secs > 60) {
      min = (sec / 60).floor();
      sec = sec % 60;
    }

    return (min >= 10 ? min.toString() : '0' + min.toString()) +
        ":" +
        (sec >= 10 ? sec.toString() : '0' + sec.toString());
  }

  static int parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    int tim = Duration(hours: hours, minutes: minutes, microseconds: micros)
        .inSeconds;
    print("current video duration = " + tim.toString());
    return tim;
  }

  static String formatDatestamp(int timestamp) {
    var format = new DateFormat('EEE, MMM d, yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  static String formatTimestamp(int timestamp) {
    var format = new DateFormat('hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  static String formatFullDatestamp(int timestamp) {
    var format = new DateFormat('EEE, MMM d, yyyy hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }

  static String formatMilliSecondsFullDatestamp(int timestamp) {
    var format = new DateFormat('EEE, MMM d, yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }

  static String formatMilliSecondsFullDTime(int timestamp) {
    var format = new DateFormat('hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }
}
