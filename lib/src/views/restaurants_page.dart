import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/blocs/suburban_spoon_provider.dart';
import 'package:flutter_coding_challenge/src/models/cuisine.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/models/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantsPage extends StatelessWidget {
  final ZomatoLocation location;
  final Cuisine cuisine;
  final int priceRange;

  const RestaurantsPage({Key key, this.location, this.cuisine, this.priceRange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suburbanSpoonBloc = SuburbanSpoonProvider.of(context);
    suburbanSpoonBloc.queryRestaurants(location, cuisine, priceRange);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Restaurants"),
      ),
      body: StreamBuilder<List<Restaurant>>(
        stream: suburbanSpoonBloc.restaurants,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.isNotEmpty) {
            return buildList(context, snapshot.data);
          } else if (snapshot.data != null && snapshot.data.isEmpty) {
            return Center(
              child: Text('No Results, better luck next time!'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Oops! An Error occurred, please try again later.'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildList(BuildContext context, List<Restaurant> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return ListTile(
          contentPadding: EdgeInsets.all(8),
          subtitle: Text(item.address),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item.name),
              Text('\$' * item.priceRange),
            ],
          ),
          leading: CachedNetworkImage(
            imageUrl: item.thumbUrl,
            placeholder: (context, str) => Icon(
              Icons.restaurant,
              size: 55,
            ),
          ),
          trailing: CircleAvatar(
            backgroundColor: Color(item.rating.colorHex),
            child: Text(item.rating.average),
          ),
          onTap: () async {
            final url =
                'https://www.google.com/maps/search/?api=1&query=${item.position.latitude},${item.position.longitude}';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Oops!'),
                    content: Text(
                        'There was a problem opening maps, try again later.'),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
