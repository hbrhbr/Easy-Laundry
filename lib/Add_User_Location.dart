import 'dart:async';
import 'dart:convert';
import 'package:easy_laundry/Screens/Home_Screen.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/placeLocation.dart';
import 'package:easy_laundry/providers/Location_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as a;
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

class MyOwnMap extends StatefulWidget {
  LatLng init_map_Postion;
  final String address;
  bool is_drawer;
  MyOwnMap({this.init_map_Postion, @required this.address,this.is_drawer});
  @override
  _MyOwnMapState createState() => _MyOwnMapState();
}

class _MyOwnMapState extends State<MyOwnMap> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController Controller_User_Address = TextEditingController();
  FocusNode myFocusNode;
  String _currentAddress;
  LatLng _center;
  final Set<Marker> _markers = {};
  Marker mymarker;
  Location_Model LocationData;
  LatLng _lastMapPosition;
  List<MapType> Map_Types = [
    MapType.normal,
    MapType.satellite,
    MapType.hybrid,
    MapType.terrain,
  ];
  int i = 0;
  MapType _currentMapType = MapType.normal;

  String kGoogleApiKey = "AIzaSyAN4tsGmE-RsxGB82EKtl4d_OL7fouiabA";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyAN4tsGmE-RsxGB82EKtl4d_OL7fouiabA");

  Future<Prediction>_places_search()async{
    Future<Prediction> p = PlacesAutocomplete.show(
        context: context,
        startText: Controller_User_Address.text,
        logo: SizedBox(),
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, user.user_country_iso_code)]);
    return p;
  }




  void _onMapTypeButtonPressed() {
    setState(() {
      if (i == Map_Types.length) i = 0;
      _currentMapType = Map_Types[i];
      i++;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _getCurrentLocation() async{
    try {
      Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _lastMapPosition = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(_lastMapPosition);
    }catch(e){
      print("Exception = $e");
    }
  }

  _getAddressFromLatLng(LatLng Address) async {
    try {
      Placemark place =await  PlaceLocation.GetAddressFromLatLng(Address);
      if(place.subLocality != null)
        _currentAddress =
        "${place.subLocality},  ${place.locality} ${place.country}";
      else
        _currentAddress =
        "${place.locality} ${place.country}";
      Controller_User_Address.text = _currentAddress;
      var m = Marker(
        markerId: MarkerId(place.toString()),
        position:LatLng(place.position.latitude, place.position.longitude) ,
        infoWindow: InfoWindow(
          title: _currentAddress,
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      setState(() {
        _lastMapPosition= LatLng(place.position.latitude, place.position.longitude);
        _markers.clear();
        _markers.add(m);
      });
      CameraPosition _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: _lastMapPosition,
          zoom: 15);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
      user.latitude = _lastMapPosition.latitude;
      user.longitude = _lastMapPosition.longitude;
      LocationData.addLocation(_lastMapPosition,m,_currentAddress);
      setState(() {
        is_Loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  _OnTapHandle(LatLng point) {
    _getAddressFromLatLng(point);
  }


  Geolocator geolocator;
  _check_Permission()async{
    a.Location _cur_location = a.Location();
    bool _serviceEnabled;
    a.PermissionStatus _permissionGranted;
    a.LocationData loc = await _cur_location.getLocation();
    _serviceEnabled = await _cur_location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _cur_location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _cur_location.hasPermission();
    if (_permissionGranted == a.PermissionStatus.denied) {
      _permissionGranted = await _cur_location.requestPermission();
      if (_permissionGranted != a.PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    _check_Permission();
    geolocator = Geolocator()..forceAndroidLocationManager = true;
    myFocusNode = FocusNode();
    if (widget.init_map_Postion == null) {
      _center = LatLng(31.484413,74.323195);
    } else {
      _center = widget.init_map_Postion;
      Controller_User_Address.text = widget.address;
      _markers.add(Marker(
        markerId: MarkerId(_center.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title:widget.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }
    _lastMapPosition = _center;
    super.initState();
  }
  bool is_Loading = false;
  @override
  Widget build(BuildContext context) {
    LocationData = Provider.of<Location_Model>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(' Location'),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: ()async{
                    Prediction p = await _places_search();
                    setState(() {
                      is_Loading=true;
                    });
                    if(p!=null) {
                      Controller_User_Address.text = p.description;
                      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
                      final lat = detail.result.geometry.location.lat;
                      final lng = detail.result.geometry.location.lng;
                      var m = Marker(
                        markerId: MarkerId(detail.result.geometry.location.toString()),
                        position: LatLng(lat,lng),
                        infoWindow: InfoWindow(
                          title: p.description,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      );
                      setState(() {
                        _lastMapPosition = LatLng(lat,lng);
                        _markers.clear();
                        _markers.add(m);
                      });
                      CameraPosition _kLake = CameraPosition(
                          bearing: 192.8334901395799,
                          target: _lastMapPosition,
                          zoom: 15);
                      final GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
                      user.latitude = _lastMapPosition.latitude;
                      user.longitude = _lastMapPosition.longitude;
                      LocationData.addLocation(_lastMapPosition, m,p.description);
                      setState(() {
                        is_Loading=false;
                      });
                    }
                  },
                  iconSize: 20,
                ),
              ],
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, _lastMapPosition);
                }),

          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                compassEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                onTap: _OnTapHandle,
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 20),
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('^[0-9 A-Z a-z , ]*'))
                        ],
                        onTap: (){
                          _places_search();
                        },
                        controller: Controller_User_Address,
                        toolbarOptions: ToolbarOptions(
                            cut: true, paste: true, selectAll: true),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            labelText: "Address",
                            errorStyle: TextStyle(fontSize: 15),
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                        focusNode: myFocusNode,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 80),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 1,
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.map,
                          size: 36.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FloatingActionButton(
                        heroTag: 2,
                        onPressed: (){
                          setState(() {
                            is_Loading=true;
                          });
                          _getCurrentLocation();
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.my_location,
                            color: Colors.white, size: 36.0),
                      ),
                    ],
                  ),
                ),
              ),
              is_Loading?
              Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(strokeWidth: 3,),
              ):SizedBox(),
              widget.is_drawer?
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text("Update Location",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        is_Loading=true;
                      });
                      _update_Loc();
                    },
                  ),
                ),
              ):SizedBox()
            ],
          )),
    );
  }
  _update_Loc()async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    try {
      double lng = user.longitude;
      double lat = user.latitude;
      final response = await http.post(
          K_API_Initial_Address + "users/update",
          headers: headers,
          body: json.encode(
              {
                  "user": {
                    "user_id": user.user_id,
                  },
                  "address": {
                    "latitude":lat.toString(),
                    "longitude": lng.toString(),
                  }
              }
          ));
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        MyToast(msg: "Location Updated Successfully");
        setState(() {
          is_Loading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext) => Home_Screen()));
      }
      else {
        MyToast(msg: "Failed to Update");
        setState(() {
          is_Loading = false;
        });
      }
    }catch(e){
      print("Exception = $e");
      // MyToast(msg: "Error = $e");
      MyToast(msg: "Error while Updating Location\n Please try again");
      setState(() {
        is_Loading=false;
      });
    }
  }
}
