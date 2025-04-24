import 'package:flutter/material.dart';

class MessengerHelper {
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 41, 69, 41),
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 41, 69, 41),
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
