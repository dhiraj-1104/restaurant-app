import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:restaurant_app/core/exception_handler.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/model/restaurant_detail.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> headers;
  ApiClient(this.baseUrl, this.headers);

  final _client = HttpClient();

  Future<List<Restaurant>> getRestaurant(String query,int page) async {
    try {
      //creating a request
      HttpClientRequest request = await _client.postUrl(
        Uri.parse(
          "$baseUrl/restaurant/search?lang=en&storeCode=KW&page=$page&perPage=10&q=$query&categoryId=&macroCategoryId=&nearBy=&sortBy=1&homeManagementId=&latlng=29.3800453,47.9744896&userId=1f60cddc-ae03-4430-b8d7-deb6bf63846c&calories=&carbs=&proteins=&fats=&isCheat=0",
        ),
      );
      //setting the header

      headers.forEach(
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
      } else {
        throw Exception("${response.statusCode} Couldn't reach the server. Try again later.");
      }
    } catch (e) {
      final errMsg = ExceptionHandler.exceptionHandler(e);
      log(errMsg);
      throw errMsg;
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(int id) async {
    try {
      HttpClientRequest req = await _client.getUrl(
        Uri.parse(
          "$baseUrl/restaurant/details?lang=en&storeCode=KW&currencyCode=KD&restaurantId=$id&userId=1f60cddc-ae03-4430-b8d7-deb6bf63846c&latlng=29.3800453,47.9744896",
        ),
      );
      headers.forEach((key, value) => req.headers.set(key, value));

      HttpClientResponse res = await req.close();
      if (res.statusCode == 200) {
        String body = await res.transform(utf8.decoder).join();
        log(body);
        RestaurantDetail details = RestaurantDetail.fromJson(jsonDecode(body)['data']);
        return details;
      }else{
        throw Exception("${res.statusCode} Couldn't reach the server. Try again later.");
      }
    } catch (e) {
      final errMsg = ExceptionHandler.exceptionHandler(e);
      throw errMsg;
    }
  }
}
