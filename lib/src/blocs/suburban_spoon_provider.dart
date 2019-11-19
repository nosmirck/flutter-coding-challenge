import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/blocs/suburban_spoon_bloc.dart';

class SuburbanSpoonProvider extends InheritedWidget {
  final SuburbanSpoonBloc bloc;

  SuburbanSpoonProvider({Key key, Widget child})
      : bloc = SuburbanSpoonBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static SuburbanSpoonBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SuburbanSpoonProvider)
            as SuburbanSpoonProvider)
        .bloc;
  }
}
