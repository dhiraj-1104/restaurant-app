import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/core/app_config.dart';
import 'package:restaurant_app/core/exception_handler.dart';
import 'package:restaurant_app/model/restaurant.dart';

class ApiClient {
  final BuildContext context;
  ApiClient(this.context);

  AppConfig get _appConfig => AppConfig.of(context);

  final client = HttpClient();

  Future<List<Restaurant>> getRestaurant() async {
    try {
      //creating a request
      HttpClientRequest request = await client.postUrl(
        Uri.parse(
          "${_appConfig.baseUrl}/restaurant/search?lang=en&storeCode=KW&page=1&perPage=20&q=&categoryId=&macroCategoryId=&nearBy=&sortBy=1&homeManagementId=&latlng=29.3800453,47.9744896&userId=1f60cddc-ae03-4430-b8d7-deb6bf63846c&calories=&carbs=&proteins=&fats=&isCheat=0",
        ),
      );
      //setting the header

      _appConfig.headers.forEach(
        (key, value) => request.headers.set(key, value),
      );

      //body
      request.write(jsonEncode({"categoryId": ""}));

      //getting resposne
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        String body = await response.transform(utf8.decoder).join();
        final decoded = jsonDecode(body);
        final List<Restaurant> restaurants =
            (decoded["data"]["restaurants"] as List)
                .map((e) => Restaurant.fromJson(e))
                .toList();
        return restaurants;
      }else{
        throw HttpException("Status code: ${response.statusCode}");
      }
     
    } catch (e) {
      final errMsg = ExceptionHandler.exceptionHandler(e);
      log(errMsg);
      rethrow;
    }
  }
}
