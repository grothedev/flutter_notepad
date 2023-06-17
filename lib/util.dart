//some utility functions
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void toast(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 5),
  ));
}

