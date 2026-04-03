import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String baseUrl;
  final Map<String, String> headers;
  const AppConfig({
    super.key,
    required this.baseUrl,
    required this.headers,
    required super.child,
  });

  static AppConfig of(BuildContext context) {
    final AppConfig? result = context
        .dependOnInheritedWidgetOfExactType<AppConfig>();
    assert(result != null, "No AppConfig found in context");
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppConfig oldWidget) {
    return baseUrl != oldWidget.baseUrl || headers != oldWidget.headers;
  }
}
