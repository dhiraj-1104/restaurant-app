import 'package:flutter/material.dart';

class ErrorFallback extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorFallback({
    super.key,
    this.message = "Something went wrong!",
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
