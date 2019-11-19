import 'dart:async';

import 'package:flutter_coding_challenge/src/models/cuisine.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/models/restaurant.dart';
import 'package:flutter_coding_challenge/src/repositories/zomato_repository.dart';
import 'package:get_it/get_it.dart';

class SuburbanSpoonBloc {
  final ZomatoRepository _zomatoRepository;

  final _cuisinesFetchController = StreamController<List<Cuisine>>();
  final _currentLocationController =
      StreamController<ZomatoLocation>.broadcast();
  final _restaurantsFetchController =
      StreamController<List<Restaurant>>.broadcast();

  SuburbanSpoonBloc()
      : _zomatoRepository = GetIt.instance.get<ZomatoRepository>() {
    currentLocation.listen(queryCuisines);
  }

  Stream<ZomatoLocation> get currentLocation =>
      _currentLocationController.stream;
  Stream<List<Cuisine>> get cuisines => _cuisinesFetchController.stream;
  Stream<List<Restaurant>> get restaurants =>
      _restaurantsFetchController.stream;

  List<int> get priceRange => [1, 2, 3];

  Future queryCuisines(ZomatoLocation location) async {
    final cuisinesList = await _zomatoRepository.fetchCuisines(location);
    _cuisinesFetchController.sink.add(cuisinesList);
  }

  Future queryRestaurants(
      ZomatoLocation location, Cuisine cuisine, int priceRange) async {
    try {
      final restaurantsList =
          await _zomatoRepository.fetchRestaurants(location, cuisine);
      int Function(Restaurant, Restaurant) comparer;
      switch (priceRange) {
        case 1:
          comparer = (a, b) => a.priceRange.compareTo(b.priceRange);
          break;
        case 2:
          comparer = (a, b) {
            return ((a.priceRange == 2 && b.priceRange == 2) ||
                    (a.priceRange != 2 && b.priceRange != 2))
                ? a.priceRange.compareTo(b.priceRange)
                : a.priceRange == 2 ? -1 : 1;
          };
          break;
        case 3:
          comparer = (a, b) => b.priceRange.compareTo(a.priceRange);
          break;
      }
      restaurantsList.sort(comparer);
      _restaurantsFetchController.sink.add(restaurantsList);
    } on Exception catch (ex) {
      _restaurantsFetchController.sink.addError(ex);
    }
  }

  void setCurrentLocation(ZomatoLocation location) {
    if (location != null) {
      _currentLocationController.sink.add(location);
    }
  }

  dispose() {
    _restaurantsFetchController.close();
    _cuisinesFetchController.close();
    _currentLocationController.close();
  }
}
