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
            "Y8FyZBClwGhrOYaq1sOi5Kr+vqgI9ZUlRWuqzVaqljqSzejGXrxD158TZ0fSbJWbugCpYXu8w6PeRSpZjgZJ+Vur1B0ktJDByxpgVdweAJ+4CO1YQ5DltkgFjk+TmgmTmFNc/IwFAVGBtu2kCeWVZUf7t5A/dKkQUdCBdfkJaVkYHQRbM+ekxvpVLWsrBp8wLsM12O2UJiy01EMd7MlUUyErdT9K9+047LTgMTZXs5fiKkPP1GJKx7BjAjMIIF7Mf3k1Z6BQZ0bv/+orMLaGYbpoRvClPdEpRV23pZfeTqE=sessiontoken",
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
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home:RestaurantListScreen(),
    );
  }
}
