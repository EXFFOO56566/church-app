import 'package:flutter/material.dart';
import 'dart:math';

class Notes {
  final int id;
  final Color color;
  final String title, content;
  final int date;

  Notes({this.id, this.title, this.content, this.date, this.color});

  static const String TABLE = "notes";
  static final tableColumns = ["id", "title", "content", "date"];

  factory Notes.fromMap(Map<String, dynamic> data) {
    return Notes(
        id: data['id'],
        title: data['title'],
        content: data['content'],
        date: data['date'],
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "date": date,
        "color": color
      };
}
