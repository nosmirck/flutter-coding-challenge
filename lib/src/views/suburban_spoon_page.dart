import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/blocs/location_search_provider.dart';
import 'package:flutter_coding_challenge/src/blocs/suburban_spoon_provider.dart';
import 'package:flutter_coding_challenge/src/models/cuisine.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/views/location_search_delegate.dart';
import 'package:flutter_coding_challenge/src/views/restaurants_page.dart';
import 'package:flutter_coding_challenge/src/widgets/slot_machine.dart';

class SuburbarSpoonPage extends StatelessWidget {
  const SuburbarSpoonPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationSearchBloc = LocationSearchProvider.of(context);
    final suburbanSpoonBloc = SuburbanSpoonProvider.of(context);
    final appbar = AppBar(
      backgroundColor: Colors.blueGrey,
      title: Center(child: Text("Suburban Spoon")),
      leading: IconButton(
        key: Key('searchButton'),
        icon: Icon(Icons.search),
        onPressed: () async {
          final location = await showSearch(
            context: context,
            delegate: LocationSearchDelegate(),
          );
          if (location != null) {
            locationSearchBloc.storeSearchHistory(location);
            suburbanSpoonBloc.setCurrentLocation(location);
          }
        },
      ),
      actions: <Widget>[
        IconButton(
          key: Key('locationButton'),
          icon: Icon(
            Icons.location_searching,
          ),
          onPressed: () {
            locationSearchBloc.useGeocoder().then((location) {
              if (location != null)
                suburbanSpoonBloc.setCurrentLocation(location);
            });
          },
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appbar,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrains) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constrains.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.grey, Colors.blueGrey, Colors.black],
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 25, bottom: 25),
                    child: StreamBuilder<ZomatoLocation>(
                      stream: suburbanSpoonBloc.currentLocation,
                      builder: (context, locationSnapshot) {
                        if (locationSnapshot.hasData) {
                          var location = locationSnapshot.data;
                          return StreamBuilder<List<Cuisine>>(
                            stream: suburbanSpoonBloc.cuisines,
                            builder: (context, cuisineSnapshot) {
                              if (cuisineSnapshot.hasData) {
                                var reelsContent = [
                                  cuisineSnapshot.data,
                                  suburbanSpoonBloc.priceRange
                                      .map((p) => '\$' * p)
                                      .toList()
                                ];
                                return buildMachine(context, constrains,
                                    reelsContent, location);
                              } else if (cuisineSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'An Error occured, please try again later.\n${cuisineSnapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          );
                        } else {
                          return Center(
                            key: Key('noLocation'),
                            child: Text(
                              'Please, Search or Share your Location.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget buildMachine(BuildContext context, BoxConstraints constrains,
      List<List<dynamic>> reelsContent, ZomatoLocation location) {
    return SlotMachine(
      reelsContent: reelsContent,
      maxWidth: constrains.maxWidth,
      onSpinStart: () {},
      onSpinEnd: (result) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantsPage(
              location: location,
              cuisine: result.first as Cuisine,
              priceRange: (result.last as String).length,
            ),
          ),
        );
      },
    );
  }
}
