import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_app/core/api_client.dart';
import 'package:restaurant_app/core/app_config.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/screens/restaurant_detail_screen.dart';
import 'package:restaurant_app/widgets/error_fallback.dart';
import 'package:restaurant_app/widgets/restaurant_card.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final ScrollController _scrollController = ScrollController();
  late AppConfig config;
  late ApiClient api;
  List<Restaurant> _restaurants = [];
  int page = 1;
  bool isLoading = false;
  bool isPaginationLoading = false;
  bool hasMore = true;
  int perPage = 10;
  String? errMsg;
  Timer? _debounce;

  String currentQuery = "";

  void fetchRestaurants(
    String query,
    int page, {
    bool isFirstLoad = false,
  }) async {
    if (isLoading || isPaginationLoading) return;

    if (isFirstLoad) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isPaginationLoading = true;
      });
    }

    try {
      log("API CALL START | Page: $page | Query: $query");
      final res = await api.getRestaurant(query, page);
      log(res.toString());
      setState(() {
        if (isFirstLoad) {
          _restaurants = res;
        } else {
          _restaurants.addAll(res);
        }

        hasMore = res.length == perPage;
        isLoading = false;
        isPaginationLoading = false;
      });
      log("Response success");
      log("Items received: ${res.length}");
      log("hasMore: $hasMore");
    } catch (e) {
      isLoading = false;
      isPaginationLoading = false;
      errMsg = e.toString();
      setState(() {});
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      log("Scroll extentAfter: ${_scrollController.position.extentAfter}");
      if (_scrollController.position.extentAfter < 300 &&
          !isLoading &&
          hasMore) {
        log("Triggering pagination | Next page: ${page + 1}");
        page++;
        log(page.toString());
        fetchRestaurants(currentQuery, page);
      }
    });
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      config = AppConfig.of(context);
      api = ApiClient(config.baseUrl, config.headers);
      fetchRestaurants(currentQuery, 1, isFirstLoad: true);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Semantics(
                label: "Search bar for searching the restaurants",
                hint: "Search the restaurants",
                child: TextField(
                  onChanged: (value) async {
                    if(_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(Duration(seconds: 2), () {
                      currentQuery = value;
                      page = 1;
                      hasMore = true;
                      fetchRestaurants(value, 1, isFirstLoad: true);
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Color(0xffF6F6F6),
                    filled: true,
                    hintText: "Search Restaurant",
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
              ),
              SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : errMsg != null
                    ? ErrorFallback(message: errMsg!)
                    : _restaurants.isEmpty
                    ? Center(child: Text("No Restaurant found."))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            _restaurants.length + (isPaginationLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _restaurants.length) {
                            final restaurant = _restaurants[index];
                            log(restaurant.image);
                            return Semantics(
                              label:
                                  "${restaurant.name}, rating ${restaurant.rating} stars, delivery in ~${restaurant.deliveryTime} minutes, distance ~${restaurant.distance} km",
                              hint: "Tap to view restaurant details",
                              button: true,
                              child: RestaurantCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantDetailScreen(
                                            id: restaurant.id,
                                            imgLogo: restaurant.logo,
                                          ),
                                    ),
                                  );
                                },
                                id: restaurant.id,
                                restaurantLogo: restaurant.logo,
                                restaurantName: restaurant.name,
                                restaurantrating: restaurant.rating,
                                categoryName: restaurant.category,
                                distance: restaurant.distance,
                                deliveryTime: restaurant.deliveryTime,
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
