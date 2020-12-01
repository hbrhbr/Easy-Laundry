import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location_Model with ChangeNotifier {
  LatLng user_Location  = null;
  Marker marker;
  String User_Address = "";
  bool is_Location = false;
  Set<Marker>markers = {};
  void addLocation(LatLng user_LatLng, Marker marker,String Address) {
    user_Location = user_LatLng;
    markers.clear();
    User_Address = Address;
    markers.add(marker);
    is_Location = true;
    notifyListeners();
    }
  void updateLocation(user_LatLng) {
    user_Location =  user_LatLng;
    is_Location =true;
    notifyListeners();
  }

  void clearLocation() {
    user_Location = null;
    is_Location = false;
    markers.clear();
    notifyListeners();
  }
}
