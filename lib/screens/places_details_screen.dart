import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/place-details';
  const PlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(title: Text(selectedPlace.title)),
      body: Column(children: [
        Container(
          height: 200,
          width: double.infinity,
          child: Image.file(
            selectedPlace.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          selectedPlace.location.address,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          child: Text('View on Map'),
          style: TextButton.styleFrom(
              primary: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => MapScreen(
                    initLoc: LatLng(selectedPlace.location.latitude,
                        selectedPlace.location.longitude))));
          },
        )
      ]),
    );
  }
}
