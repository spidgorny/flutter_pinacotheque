import 'package:sqljocky5/sqljocky.dart' as sql;

class MyImage {
  sql.Row row;

  MyImage(sql.Row row) {
    this.row = row;
  }

  int get file {
    return this.row.byName('id');
  }

  DateTime get dateTime {
    String sDateTime = this.row.byName('DateTime');
    print(sDateTime);
    double dTimestamp = this.row.byName('timestamp');

    DateTime dateTime;
    if (sDateTime != null) {
      try {
        var parts = sDateTime.split(' ');
        String date = parts[0];
        String time = parts[1];
        date = date.replaceAll(':', '-');
        dateTime = DateTime.parse(date + ' ' + time);
      } catch (e) {
        dateTime = new DateTime.fromMillisecondsSinceEpoch(dTimestamp.floor());
      }
    } else {
      dateTime = new DateTime.fromMillisecondsSinceEpoch(dTimestamp.floor());
    }
    print(dateTime);
    return dateTime;
  }

  int get year {
    var dateTime = this.dateTime;
    return dateTime.year;
  }

  int get month {
    var dateTime = this.dateTime;
    return dateTime.month;
  }

  String get humanTime {
    return this.dateTime.toIso8601String().replaceAll('T', ' ');
  }
}
