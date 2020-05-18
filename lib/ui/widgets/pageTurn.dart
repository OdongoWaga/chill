import 'package:flutter/material.dart';

void pageTurn(Widget pageName, context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return pageName;
      },
    ),
  );
}
