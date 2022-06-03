import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/places_details_screen.dart';
import 'package:great_places/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ThemeData _themeData = ThemeData();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: GreatPlaces(),
        child: MaterialApp(
          title: 'Great Places',
          theme: _themeData.copyWith(
              colorScheme: _themeData.colorScheme
                  .copyWith(primary: Colors.indigo, secondary: Colors.amber)),
          home: const PlacesListScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => const AddPlaceScreen(),
            PlaceDetailsScreen.routeName: (ctx) => const PlaceDetailsScreen(),
          },
        ));
  }
}
