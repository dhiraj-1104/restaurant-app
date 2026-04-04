import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final int id;
  final String restaurantName;
  final double restaurantrating;
  final String restaurantLogo;
  final List<String> categoryName;
  final double distance;
  final double deliveryTime;
  final VoidCallback onTap;
  const RestaurantCard({
    super.key,
    required this.restaurantName,
    required this.restaurantrating,
    required this.restaurantLogo,
    required this.categoryName,
    required this.distance,
    required this.deliveryTime,
    required this.onTap,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Hero(
              tag: id,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),

                width: 100,
                child: Image.network(
                  restaurantLogo,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/images/broken_image.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontFamily: "Sen",
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "🌟 $restaurantrating ~$deliveryTime min",
                      style: TextStyle(
                        fontFamily: "Sen",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (categoryName.isNotEmpty)
                      Text(
                        categoryName.join(", "),
                        style: TextStyle(fontFamily: "Sen", color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      "~$distance Km",
                      style: TextStyle(fontFamily: "Sen", color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
