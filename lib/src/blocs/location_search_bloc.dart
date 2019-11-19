import 'dart:async';
import 'dart:convert';

import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/models/position.dart';
import 'package:flutter_coding_challenge/src/repositories/zomato_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kHistorySearchKey = 'SEARCH_HISTORY';

class LocationSearchBloc {
  List<ZomatoLocation> _history;
  final ZomatoRepository _zomatoRepository;
  final Location _locationService;
  final SharedPreferences _sharedPrefs;

  final _locationFetchController =
      StreamController<List<ZomatoLocation>>.broadcast();
  final _geocoderController = StreamController<ZomatoLocation>.broadcast();

  LocationSearchBloc()
      : _locationService = GetIt.instance.get<Location>(),
        _zomatoRepository = GetIt.instance.get<ZomatoRepository>(),
        _sharedPrefs = GetIt.instance.get<SharedPreferences>() {
    _history = _sharedPrefs
        .getStringList(_kHistorySearchKey)
        ?.map((str) => ZomatoLocation.fromMap(json.decode(str)))
        ?.toList();
  }

  Stream<List<ZomatoLocation>> get currentLocation =>
      _locationFetchController.stream;
  Stream<ZomatoLocation> get geocoder => _geocoderController.stream;
  List<ZomatoLocation> get history => _history;

  Future queryLocations(String query) async {
    final locations = await _zomatoRepository.fetchLocations(query);
    _locationFetchController.sink.add(query.isEmpty ? null : locations);
  }

  Future<ZomatoLocation> useGeocoder() async {
    var hasPermission = await _locationService.hasPermission();
    var requestPermission = await _locationService.requestPermission();
    if (hasPermission || requestPermission) {
      final locationData = await _locationService.getLocation();
      final position = Position(locationData.latitude, locationData.longitude);
      final location = await _zomatoRepository.fetchGeocode(position);
      return location;
    }
    return null;
  }

  Future storeSearchHistory(ZomatoLocation location) async {
    if (location == null) return;
    if (_history != null) {
      _history.removeWhere((loc) => loc.id == location.id);
      _history.insert(0, location);
    } else {
      _history = [location];
    }
    _history = _history.take(10).toList();
    _sharedPrefs.setStringList(_kHistorySearchKey,
        _history.map((l) => json.encode(l.toMap())).toList());
  }

  dispose() {
    _locationFetchController.close();
    _geocoderController.close();
  }
}
