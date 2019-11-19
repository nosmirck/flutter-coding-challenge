import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/repositories/zomato_repository.dart';
import 'package:flutter_coding_challenge/src/suburban_spoon_app.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  await registerDependencies();
  runApp(SuburbanSpoonApp());
}

Future registerDependencies() async {
  GetIt.instance.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  GetIt.instance
      .registerSingleton<ZomatoRepository>(ZomatoRepository(Client()));
  GetIt.instance.registerSingleton<Location>(Location());
}
