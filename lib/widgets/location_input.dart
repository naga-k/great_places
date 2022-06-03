import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    final location = await LocationHelper.getLocationInstance();
    if (location == null) {
      return;
    }
    final locationData = await location.getLocation();
    print("$locationData.longitude $locationData.latitude");
    _showPreview(locationData.latitude!, locationData.longitude!);
    widget.onSelectPlace(locationData.latitude!, locationData.longitude!);
  }

  Future<void> _selectOnMap() async {
    LatLng initLoc = await LocationHelper.getLatitudeAndLongitude();
    LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          initLoc: initLoc,
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? const Text('No Location Chosen', textAlign: TextAlign.center)
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (ctx, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary),
            ),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                label: Text("Select on Map"),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary)),
          ],
        )
      ],
    );
  }
}
