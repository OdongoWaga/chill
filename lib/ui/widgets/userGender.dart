import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget userGender(gender) {
  switch (gender) {
    case 'Male':
      return Icon(
        FontAwesomeIcons.mars,
        color: Colors.white,
      );
      break;
    case 'Female':
      return Icon(
        FontAwesomeIcons.venus,
        color: Colors.white,
      );
      break;
    case 'Transgender':
      return Icon(
        FontAwesomeIcons.transgender,
        color: Colors.white,
      );
      break;
    default:
      return null;
      break;
  }
}
