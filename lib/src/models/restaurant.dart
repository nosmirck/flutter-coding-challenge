import 'package:flutter_coding_challenge/src/models/position.dart';

class Restaurant {
  final String id;
  final String name;
  final String url;
  final String currency;
  final String thumbUrl;
  final String imageUrl;
  final int priceRange;
  final String cuisines;
  final String address;
  final Rating rating;
  final Position position;

  Restaurant.fromMap(Map map)
      : id = map['id'],
        name = map['name'],
        url = map['url'],
        thumbUrl = map['thumb'],
        imageUrl = map['featured_image'],
        priceRange = map['price_range'],
        currency = map['currency'],
        cuisines = map['cuisines'],
        address = map['location']['address'],
        rating = Rating.fromMap(map['user_rating']),
        position = Position(double.parse(map['location']['latitude']),
            double.parse(map['location']['longitude']));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Restaurant && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Rating {
  final String text;
  final String average;
  final String color;

  int get colorHex => int.tryParse('ff$color', radix: 16);

  Rating.fromMap(Map map)
      : text = map['rating_text'].toString(),
        average = map['aggregate_rating'].toString(),
        color = map['rating_color'];
}
