import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const googleApiKey = 'YOUR_API_KEY';

class LocationHelper {
  static Future<Location?> getLocationInstance() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return location;
  }

  static Future<LatLng> getLatitudeAndLongitude() async {
    final location = await LocationHelper.getLocationInstance();
    if (location == null) {
      return const LatLng(0, 0);
    }
    final locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey";
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$googleApiKey");
    final response = await http.get(url);
    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
