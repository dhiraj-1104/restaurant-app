import 'package:flutter/material.dart';
import 'package:restaurant_app/core/app_config.dart';
import 'package:restaurant_app/screens/restaurant_list_screen.dart';

void main() {
  runApp(
    AppConfig(
      baseUrl: "https://dev-api.livelongfit.com/api/v2",
      headers: {
        "Accept": "application/json",
        "Accept-Charset": "UTF-8",
        "Content-Type": "application/json",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:127.0) Gecko/20100101",
        "auth":
            "YOUR_AUTH_TOKEN",
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: RestaurantListScreen(),
    );
  }
}
