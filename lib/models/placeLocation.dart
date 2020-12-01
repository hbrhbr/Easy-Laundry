
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceLocation {
 static  Future<Placemark> GetAddressFromLatLng(LatLng Current_Position) async {
     final Geolocator geolocator = Geolocator()..forceAndroidLocationManager=true;
      try {
          List<Placemark> p = await geolocator.placemarkFromCoordinates(
              Current_Position.latitude, Current_Position.longitude);
          Placemark place = p[0];
          return place;
      } catch (e) {
          print("Exception while getting Address from LatLng = $e");
          return null;
      }
  }
}
