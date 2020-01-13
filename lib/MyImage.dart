import 'dart:core';

import 'IImage.dart';

class MyImage extends IImage {
  int id;
  String sDateTime;
  double timestamp;

  MyImage(this.id, this.sDateTime, this.timestamp);

  int get file {
    return this.id;
  }

  DateTime get dateTime {
    DateTime dateTime;
    if (this.sDateTime != null) {
      try {
        var parts = this.sDateTime.split(' ');
        String date = parts[0];
        String time = parts[1];
        date = date.replaceAll(':', '-');
        dateTime = DateTime.parse(date + ' ' + time);
      } catch (e) {
        dateTime =
            new DateTime.fromMillisecondsSinceEpoch(this.timestamp.floor());
      }
    } else {
      dateTime =
          new DateTime.fromMillisecondsSinceEpoch(this.timestamp.floor());
    }
//    print(dateTime);
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

  String get imageURL {
    return this.baseURL + 'ShowOriginal?file=${this.file}';
  }

  String get thumbURL {
    return this.baseURL + 'ShowThumb?file=${this.file}';
  }

  String get clickURL {
    return baseURL +
        'Preview?source=0&year=${this.year}&month=${this.month}&file=${this.file}';
  }
}
