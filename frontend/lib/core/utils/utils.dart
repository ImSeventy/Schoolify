import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showToastMessage(String message, Color color, BuildContext context) {
  ToastContext().init(context);
  Toast.show(message, duration: 3, backgroundColor: color);
}