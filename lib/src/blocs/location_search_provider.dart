import 'package:flutter/material.dart';

import 'location_search_bloc.dart';

class LocationSearchProvider extends InheritedWidget {
  final LocationSearchBloc bloc;

  LocationSearchProvider({Key key, Widget child})
      : bloc = LocationSearchBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LocationSearchBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LocationSearchProvider)
            as LocationSearchProvider)
        .bloc;
  }
}
