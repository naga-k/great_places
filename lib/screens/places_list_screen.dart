import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/places_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Places List'), actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
          },
        ),
      ]),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                builder: (context, greatPlaces, child) {
                  if (greatPlaces.items.isEmpty) {
                    return child!;
                  } else {
                    return ListView.builder(
                      itemCount: greatPlaces.items.length,
                      itemBuilder: (ctx, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[index].image),
                          ),
                          title: Text(greatPlaces.items[index].title),
                          subtitle:
                              Text(greatPlaces.items[index].location.address),
                          onTap: () {
                            final latLong = Navigator.of(ctx).pushNamed(
                                PlaceDetailsScreen.routeName,
                                arguments: greatPlaces.items[index].id);
                          }),
                    );
                  }
                },
                child: Center(
                  child: const Text('No places yet, start adding some!'),
                ),
              ),
      ),
    );
  }
}
