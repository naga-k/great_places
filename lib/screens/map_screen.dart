import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng initLoc;
  final bool isSelecting;

  const MapScreen({
    Key? key,
    this.isSelecting = false,
    required this.initLoc,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = LatLng(widget.initLoc.latitude, widget.initLoc.longitude);
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initLoc.latitude, widget.initLoc.longitude),
            zoom: 16),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: {
          Marker(
            markerId: MarkerId('m1'),
            position: _pickedLocation,
          )
        },
      ),
    );
  }
}
