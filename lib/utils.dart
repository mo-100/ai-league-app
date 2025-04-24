import 'package:flutter/material.dart';

String getTimeStr(DateTime dt, BuildContext context) {
    TimeOfDay tod = TimeOfDay.fromDateTime(dt);
    return tod.format(context);
  }

String getDateStr(DateTime dt, BuildContext context) {
  return "${dt.day}/${dt.month}/${dt.year}";
  }
