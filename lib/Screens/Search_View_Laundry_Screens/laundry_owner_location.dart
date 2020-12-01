import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Laundry_Owner_Location extends StatefulWidget {
  final double lat;
  final double lng;
  final String Address;
  Laundry_Owner_Location({this.Address,this.lng,this.lat});
  @override
  _Laundry_Owner_LocationState createState() => _Laundry_Owner_LocationState();
}

class _Laundry_Owner_LocationState extends State<Laundry_Owner_Location> {
  LatLng _center;
  LatLng _lastMapPosition;
  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override void initState() {
    _center = LatLng(widget.lat, widget.lng);
    _markers.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title:widget.Address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
    _lastMapPosition = _center;
    super.initState();
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laundry Location"),
      ),
      body:  GoogleMap(
        compassEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers,
        onCameraMove: _onCameraMove,
      ),
    );
  }
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
}
