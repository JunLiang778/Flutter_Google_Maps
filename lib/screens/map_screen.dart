import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool
      isSelecting; //whether we're selecting a place or just showing alr sleected place
  //if false -> read only map
  //if true -> user can tap diff location
  MapScreen({
    this.initialLocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      //setState bc re-render marker on map
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                icon: Icon(Icons.check),
                //enable the button only when user picked a place
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context)
                            .pop(_pickedLocation); //return pickedLocation
                      }),
        ],
      ),
      //initialCameraPosition -> the location which is focused when app launches
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.initialLocation.latitude,
              widget.initialLocation.longitude,
            ),
            zoom: 16,
          ),
          onTap: widget.isSelecting ? _selectLocation : null,
          //show no markers if no _pickedLocation AND isSelecting is true
          markers: (_pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                    markerId: MarkerId('m1'),
                    position: _pickedLocation ??
                        LatLng(
                          widget.initialLocation.latitude,
                          widget.initialLocation.longitude,
                        ),
                    //if pickedLocation is null (aka when we're on "View on Map" mode), we wanna fallback the value to initialLocation
                  ),
                }
          //Set is like a Map but u dont have key-value pairs but u only have values
          //The special thing about a Set is that each value in there is unique
          ),
    );
  }
}
