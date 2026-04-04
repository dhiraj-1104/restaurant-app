import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_app/core/api_client.dart';
import 'package:restaurant_app/core/app_config.dart';
import 'package:restaurant_app/model/restaurant_detail.dart';
import 'package:restaurant_app/widgets/error_fallback.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int id;
  final String imgLogo;
  const RestaurantDetailScreen({
    super.key,
    required this.id,
    required this.imgLogo,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool _isWorkingDays = false;
  bool _isMenu = false;
  late ApiClient _apiClient;
  RestaurantDetail? detail;
  bool _isLoadind = false;
  bool _isInit = false;
  String? errMsg;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      AppConfig config = AppConfig.of(context);
      _apiClient = ApiClient(config.baseUrl, config.headers);
      fetchRestaurantDetails();
      _isInit = true;
    }
  }

  void fetchRestaurantDetails() async {
    try {
      _isLoadind = true;
      final data = await _apiClient.getRestaurantDetail(widget.id);
      log(data.toString());
      setState(() {
        detail = data;
        _isLoadind = false;
      });
      log("Logo: ${data.logo}");
    } catch (e) {
      _isLoadind = false;
      errMsg = e.toString();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Restaurant Details",
          style: TextStyle(fontFamily: "Sen", fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 300 / 200,
                      child: Hero(
                        tag: widget.id,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Image.network(
                            widget.imgLogo,
                            gaplessPlayback: true,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                                  "https://d1ysvv612yuqgo.cloudfront.net/fit-in/1000x1000/Img_1744872902606_m9l09wb23i33v2bvivl.webp",
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                        "assets/images/broken_image.png",
                                      ),
                                ),

                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _isLoadind
                        ? Center(child: CircularProgressIndicator())
                        : errMsg != null
                        ? ErrorFallback()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail?.name ?? "No Name",
                                style: TextStyle(
                                  fontFamily: "Sen",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                detail?.description ??
                                    "No Description Provided",
                                style: TextStyle(fontFamily: "Sen"),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _iconList(
                                    iconPath: "assets/images/Star.png",
                                    text: detail?.rating.toString() ?? "--",
                                  ),
                                  _iconList(
                                    iconPath: "assets/images/truck.png",
                                    text: detail?.isFreeDelivery == true
                                        ? "Free"
                                        : detail?.isFreeDelivery == false
                                        ? "Paid"
                                        : "--",
                                  ),
                                  _iconList(
                                    iconPath: "assets/images/Clock.png",
                                    text: detail?.deliveryTime != null
                                        ? "~${detail?.deliveryTime} min"
                                        : "--",
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Tooltip(
                                    message:
                                        "Show the working hours of the restaurant",
                                    child: _customContainer(
                                      "Working Days",
                                      _isWorkingDays,
                                      () {
                                        setState(() {
                                          _isWorkingDays = true;
                                        });
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Show the menu of the restaurant",
                                    child: _customContainer(
                                      "Menu",
                                      _isMenu,
                                      () {
                                        setState(() {
                                          _isMenu = true;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Address",
                                style: TextStyle(
                                  fontFamily: "Sen",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _contactDetails(
                                detail?.address.values.join(", ") ?? "N/A",
                              ),
                              SizedBox(height: 2),
                              _contactDetails(
                                "📞 ${(detail?.supportPhone != null && detail!.supportPhone.isNotEmpty) ? detail!.supportPhone : "--"}",
                              ),
                              SizedBox(height: 2),
                              _contactDetails(
                                "✉️ ${(detail?.supportEmail != null && detail!.supportEmail.isNotEmpty) ? detail!.supportEmail : "--"}",
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              if (_isWorkingDays)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Working days",
                              style: TextStyle(
                                fontFamily: "Sen",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isWorkingDays = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xffF58D1D),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 180),
                          child: ListView.builder(
                            itemCount: detail?.workingDays?.length ?? 0,
                            itemBuilder: (context, index) {
                              final work = detail?.workingDays?[index];
                              log(work.toString());
                              if (work == null) return const SizedBox();
                              return _workingDays(
                                work['day'] ?? "N/A",
                                "${work['startTime'] ?? "--"}  - ${work['endTime'] ?? "--"}",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_isMenu)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isMenu = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xffF58D1D),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        (detail?.itemList?.isNotEmpty ?? false)
                            ? ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 350),

                                child: PageView.builder(
                                  scrollDirection: Axis.horizontal,

                                  itemCount: detail?.itemList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final item = detail?.itemList?[index];
                                    if (item == null) return SizedBox();
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1.5,
                                            child: Image.network(
                                              item['defaultImage'],
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Image.asset(
                                                    "assets/images/broken_image.png",
                                                  ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Text(
                                            item['name'],
                                            style: TextStyle(
                                              fontFamily: "Sen",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item['shortDescription'],
                                            style: TextStyle(
                                              fontFamily: "Sen",
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "₹${item['finalPrice']}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xffF58D1D),
                                                  fontFamily: "Sen",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "₹${item['regularPrice']}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  decorationColor: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.arrow_back, size: 10),
                                              Text(
                                                "Swipe left to see more Items",
                                                style: TextStyle(
                                                  fontFamily: "Sen",
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text("No Items found"),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconList({required String iconPath, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(right: 36.0),
      child: Row(
        children: [Image.asset(iconPath), SizedBox(width: 10), Text(text)],
      ),
    );
  }

  Widget _customContainer(String text, bool value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13.5),
        decoration: BoxDecoration(
          color: value ? Color(0xffF58D1D) : Colors.white,
          borderRadius: BorderRadius.circular(15),

          border: Border.all(color: value ? Color(0xffF58D1D) : Colors.black),
        ),
        child: Text(
          text,
          style: TextStyle(color: value ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _contactDetails(String contactDetail) {
    return Text(
      contactDetail,
      style: TextStyle(fontFamily: "Sen", fontSize: 12),
    );
  }

  Widget _workingDays(String day, String time) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: TextStyle(fontFamily: "Sen", fontSize: 16)),
        Text(time, style: TextStyle(fontFamily: "Sen", fontSize: 16)),
      ],
    );
  }
}
