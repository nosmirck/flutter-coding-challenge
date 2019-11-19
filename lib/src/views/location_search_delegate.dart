import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/blocs/location_search_bloc.dart';
import 'package:flutter_coding_challenge/src/blocs/location_search_provider.dart';
import 'package:flutter_coding_challenge/src/models/location.dart';

class LocationSearchDelegate extends SearchDelegate<ZomatoLocation> {
  LocationSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon((Icons.clear)),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final LocationSearchBloc bloc = LocationSearchProvider.of(context);
    bloc.queryLocations(query);

    return StreamBuilder<List<ZomatoLocation>>(
      stream: bloc.currentLocation,
      builder: (context, snapshot) {
        final suggestions = snapshot.hasData ? snapshot.data : bloc.history;
        final isHistory = !snapshot.hasData;
        if (suggestions != null && suggestions.isNotEmpty) {
          return ListView.separated(
            separatorBuilder: (context, _) => Divider(),
            itemCount: suggestions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: isHistory ? Icon(Icons.history) : null,
                title: Text(suggestions[index].title),
                onTap: () {
                  close(context, suggestions[index]);
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(isHistory ? "Enter a Location " : "No Results"),
          );
        }
      },
    );
  }
}
