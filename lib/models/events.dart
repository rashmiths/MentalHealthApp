import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Blog {
  final String imgUrl;
  final String title;
  final bool isLatest;
  final Color color;
  final String description;
  final String date;

  Blog({
    @required this.imgUrl,
    @required this.title,
    @required this.isLatest,
    @required this.color,
    @required this.description,
    @required this.date,
  });
}
