import 'package:flutter_coding_challenge/src/models/cuisine.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/models/position.dart';
import 'package:flutter_coding_challenge/src/repositories/zomato_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  group(
    'ZomatoRepository - Simple Tests to make sure the API works',
    () {
      final _zomatoRepository = ZomatoRepository(Client());
      final torontoPosition = Position(43.6, -79.3);
      final torontoLocation = ZomatoLocation(
        id: 89,
        cityId: 89,
        type: 'city',
        title: 'Toronto, Ontario',
        country: 'Canada',
      );
      final cuisine = Cuisine(id: 381, name: 'Canadian');
      test(
        'fetchCuisines',
        () async {
          final cuisines =
              await _zomatoRepository.fetchCuisines(torontoLocation);
          expect(cuisines, isNotNull);
        },
      );
      test(
        'fetchGeocode',
        () async {
          final location =
              await _zomatoRepository.fetchGeocode(torontoPosition);
          expect(location, isNotNull);
        },
      );
      test(
        'fetchLocations',
        () async {
          final locations = await _zomatoRepository
              .fetchLocations(torontoLocation.title.substring(0, 4));
          expect(locations, isNotNull);
        },
      );
      test(
        'fetchRestaurants',
        () async {
          final restaurants = await _zomatoRepository.fetchRestaurants(
              torontoLocation, cuisine);
          expect(restaurants, isNotNull);
        },
      );
    },
  );
}
