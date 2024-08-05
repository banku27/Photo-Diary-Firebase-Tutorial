import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

extension BuildContextExt on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    toastification.show(
      context: this,
      title: Text(message),
      type: isError ? ToastificationType.error : ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: true,
    );
  }
}
