import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/blocs/location_search_provider.dart';
import 'package:flutter_coding_challenge/src/blocs/suburban_spoon_provider.dart';
import 'package:flutter_coding_challenge/src/views/suburban_spoon_page.dart';

class SuburbanSpoonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocationSearchProvider(
      child: SuburbanSpoonProvider(
        child: MaterialApp(
          home: SuburbarSpoonPage(),
        ),
      ),
    );
  }
}
