import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/models/cuisine.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';
import 'package:flutter_coding_challenge/src/repositories/zomato_repository.dart';
import 'package:flutter_coding_challenge/src/suburban_spoon_app.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  await registerDependencies();
  runApp(SuburbanSpoonApp());
}

Future registerDependencies() async {
  GetIt.instance.reset();
  final mockSharedPrefs = MockSharedPreferences();
  final mockLocation = MockLocation();
  final mockZomatoRepository = MockZomatoRepository();

  when(mockSharedPrefs.getStringList(any)).thenReturn(null);
  when(mockSharedPrefs.setStringList(any, any))
      .thenAnswer((_) => Future.value(true));
  when(mockLocation.getLocation()).thenAnswer((_) => Future.value(
        LocationData.fromMap(
          {
            'latitude': 43.6,
            'longitude': -79.3,
            'accuracy': 0,
            'altitude': 0,
            'speed': 0,
            'speed_accuracy': 0,
            'heading': 0,
            'time': 0,
          },
        ),
      ));
  when(mockLocation.hasPermission()).thenAnswer((_) => Future.value(true));
  when(mockLocation.requestPermission()).thenAnswer((_) => Future.value(true));
  when(mockZomatoRepository.fetchCuisines(any)).thenAnswer((_) => Future.value(
      json
          .decode(cuisinesResponse)
          .map<Cuisine>((json) => Cuisine.fromMap(json['cuisine']))
          .toList(growable: false)));
  when(mockZomatoRepository.fetchLocations(any)).thenAnswer((_) => Future.value(
      json
          .decode(locationResponse)
          .map<ZomatoLocation>((json) => ZomatoLocation.fromMap(json))
          .toList(growable: false)));
  when(mockZomatoRepository.fetchGeocode(any)).thenAnswer((_) => Future.value(
      json
          .decode(locationResponse)
          .map<ZomatoLocation>((json) => ZomatoLocation.fromMap(json))
          .toList(growable: false)
          .first));

  GetIt.instance.registerSingleton<SharedPreferences>(mockSharedPrefs);
  GetIt.instance.registerSingleton<ZomatoRepository>(mockZomatoRepository);
  GetIt.instance.registerSingleton<Location>(mockLocation);
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockLocation extends Mock implements Location {}

class MockZomatoRepository extends Mock implements ZomatoRepository {}

const cuisinesResponse = '''
  [
    {
      "cuisine": {
        "cuisine_id": 1,
        "cuisine_name": "American"
      }
    },
    {
      "cuisine": {
        "cuisine_id": 4,
        "cuisine_name": "Canadian"
      }
    },
    {
      "cuisine": {
        "cuisine_id": 151,
        "cuisine_name": "Venezuelan"
      }
    },
    {
      "cuisine": {
        "cuisine_id": 175,
        "cuisine_name": "Indian"
      }
    },
    {
      "cuisine": {
        "cuisine_id": 3,
        "cuisine_name": "Asian"
      }
    }
  ]''';
const locationResponse = '''
  [{
    "entity_type": "city",
    "entity_id": 89,
    "title": "Toronto, Ontario",
    "latitude": 43.627499,
    "longitude": -79.396167,
    "city_id": 89,
    "city_name": "Toronto",
    "country_id": 37,
    "country_name": "Canada"
  }]''';
