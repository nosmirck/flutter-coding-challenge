import 'dart:async';
import 'dart:convert';

import 'package:flutter_coding_challenge/src/models/cuisine.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/models/position.dart';
import 'package:flutter_coding_challenge/src/models/restaurant.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class ZomatoRepository {
  final client;
  final _apiKey = '9d1149e1fddc9188d43123f5554f3dc1';
  final _host = 'developers.zomato.com';
  final _contextRoot = 'api/v2.1';

  ZomatoRepository(this.client);

  Future<List<ZomatoLocation>> fetchLocations(String query,
      [int count = 10]) async {
    assert(query != null, '<param>query</param> should not be null.');

    final result = await request(path: 'locations', parameters: {
      'query': query,
      'count': count.toString(),
    });

    final suggestions = result['location_suggestions'];
    return suggestions
        .map<ZomatoLocation>((json) => ZomatoLocation.fromMap(json))
        .toList(growable: false);
  }

  Future<ZomatoLocation> fetchGeocode(Position position) async {
    assert(position != null, '<param>position</param> should not be null.');
    final result = await request(
      path: 'geocode',
      parameters: {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
      },
    );

    return ZomatoLocation.fromMap(result['location']);
  }

  Future<List<Cuisine>> fetchCuisines(ZomatoLocation location) async {
    assert(location != null, '<param>location</param> should not be null.');
    final result = await request(
        path: 'cuisines', parameters: {'city_id': location.cityId.toString()});

    return result['cuisines']
        .map<Cuisine>((json) => Cuisine.fromMap(json['cuisine']))
        .toList(growable: false);
  }

  Future<List<Restaurant>> fetchRestaurants(ZomatoLocation location,
      [Cuisine cuisine, int skip = 0, int take = 20, String order]) async {
    assert(location != null, '<param>location</param> should not be null.');

    final results = await request(
      path: 'search',
      parameters: {
        'entity_id': location.id.toString(),
        'entity_type': location.type,
        'cuisines': cuisine?.id.toString(),
        'start': skip.toString(),
        'count': take.toString(),
        'order': order,
      },
    );

    final restaurants = results['restaurants']
        .map<Restaurant>((json) => Restaurant.fromMap(json['restaurant']))
        .toList(growable: false);

    return restaurants;
  }

  Future<dynamic> request(
      {@required String path, Map<String, String> parameters}) async {
    final uri = Uri.https(_host, '$_contextRoot/$path', parameters);
    final results = await client.get(uri, headers: _headers);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  Map<String, String> get _headers =>
      {'Accept': 'application/json', 'user-key': _apiKey};
}
