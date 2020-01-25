// To parse this JSON data, do
//
//     final httpImage = httpImageFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_pinacotheque/image/IImage.dart';

HttpImage httpImageFromJson(String str) => HttpImage.fromJson(json.decode(str));

String httpImageToJson(HttpImage data) => json.encode(data.toJson());

class HttpImage implements IImage {
  String id;
  String source;
  String type;
  String path;
  String timestamp;
  String dateTime;
  dynamic colors;
  String thumb;
  String url;
  String preview;
  String original;
  double duration;

  HttpImage({
    this.id,
    this.source,
    this.type,
    this.path,
    this.timestamp,
    this.dateTime,
    this.colors,
    this.thumb,
    this.url,
    this.preview,
    this.original,
    this.duration,
  });

  factory HttpImage.fromJson(Map<String, dynamic> json) => HttpImage(
        id: json["id"],
        source: json["source"],
        type: json["type"],
        path: json["path"],
        timestamp: json["timestamp"],
        dateTime: json["DateTime"],
        colors: json["colors"],
        thumb: json["thumb"],
        url: json["url"],
        preview: json["preview"],
        original: json["original"],
        duration: json["duration"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "type": type,
        "path": path,
        "timestamp": timestamp,
        "DateTime": dateTime,
        "colors": colors,
        "thumb": thumb,
        "url": url,
        "preview": preview,
        "original": original,
        "duration": duration,
      };

  @override
  String baseURL;

  @override
  // TODO: implement clickURL
  String get clickURL => baseURL + 'Preview?file=' + id;

  @override
  // TODO: implement humanTime
  String get humanTime => dateTime ?? '';

  @override
  // TODO: implement imageURL
  String get imageURL => original;

  @override
  void setBaseURL(String url) {
    this.baseURL = url;
  }

  @override
  // TODO: implement thumbURL
  String get thumbURL => preview;
}
