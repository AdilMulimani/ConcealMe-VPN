import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

final Map<ToastificationType, String> toastTitles = {
  ToastificationType.success: 'Success',
  ToastificationType.error: 'Error',
  ToastificationType.warning: 'Warning',
  ToastificationType.info: 'Info',
};

ToastificationItem showToast({
  required ToastificationType type,
  required String description,
}) {
  return toastification.show(
    type: type,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 5),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    showIcon: true,
    showProgressBar: true,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    primaryColor: Colors.grey[900]!,
    foregroundColor: Colors.white,
    backgroundColor: Colors.grey[100]!,
    progressBarTheme: ProgressIndicatorThemeData(
      color: _getToastColor(type),
      circularTrackColor: Colors.grey[800],
    ),
    // Text Content
    title: Text(
      toastTitles[type] ?? 'Notification',
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    description: RichText(
      text: TextSpan(
        text: description,
        style: const TextStyle(
          color: Colors.white,
        ), // Softer white for readability
      ),
    ),

    // Icon Based on Type
    icon: Icon(_getToastIcon(type), color: _getToastColor(type)),

    // Styling
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),

    // Close Button
    closeButton: ToastCloseButton(
      showType: CloseButtonShowType.onHover,
      buttonBuilder: (context, onClose) {
        return IconButton(
          icon: const Icon(Icons.close, size: 20, color: Colors.grey),
          onPressed: onClose,
        );
      },
    ),
  );
}

// Function to get icon based on Toast type
IconData _getToastIcon(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Icons.check_circle;
    case ToastificationType.error:
      return Icons.error;
    case ToastificationType.warning:
      return Icons.warning;
    case ToastificationType.info:
      return Icons.info;
    default:
      return Icons.notifications;
  }
}

// Function to get color based on Toast type
Color _getToastColor(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Colors.greenAccent;
    case ToastificationType.error:
      return Colors.redAccent;
    case ToastificationType.warning:
      return Colors.amberAccent;
    case ToastificationType.info:
      return Colors.blueAccent;
    default:
      return Colors.white;
  }
}
