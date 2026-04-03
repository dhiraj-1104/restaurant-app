import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_app/core/api_client.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  List<Restaurant> _restaurants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) async {
                ApiClient api = ApiClient(context);
                final res = await api.getRestaurant();
                log(res.toString());
                _restaurants = res;
                log("Response success");
                setState(() {});
                // log(res[0].name.toString());
                // log(res[0].rating.toString());
                // log(res[0].category.toString());
              },
              decoration: InputDecoration(
                fillColor: Color(0xffF6F6F6),
                filled: true,
                hintText: "3d kuwait",
                hintStyle: TextStyle(fontFamily: "Sen", color: Colors.grey),
                prefixIcon: Icon(Icons.search_outlined, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _restaurants[index];
                  return RestaurantCard(
                    restaurantLogo: restaurant.logo,
                    restaurantName: restaurant.name,
                    restaurantrating: restaurant.rating,
                    categoryName: restaurant.category,
                    distance: restaurant.distance,
                    deliveryTime: restaurant.deliveryTime,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
