import 'dart:convert';
import 'package:easy_laundry/Screens/Laundry_rating_screen.dart';
import 'package:easy_laundry/Screens/Search_View_Laundry_Screens/laundry_owner_location.dart';
import 'package:easy_laundry/Screens/Service_Details_Screens/view_Service_details.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/User_model.dart';
import 'package:easy_laundry/models/placeLocation.dart';
import 'package:easy_laundry/models/user_laundry.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class view_selected_profile extends StatefulWidget {
  final int user_id;
  view_selected_profile({this.user_id});

  @override
  _view_selected_profileState createState() => _view_selected_profileState();
}



class _view_selected_profileState extends State<view_selected_profile> {
  TextStyle mytextstyle(double font_size,Color text_color,FontWeight font_weight)
  {
    return TextStyle(
        fontSize: font_size,
        color: text_color,
        fontWeight: font_weight
    );
  }
  Color title_color = Colors.blue[400];
  Color content_color = Colors.black;
  double title_font=14;
  double content_font=11;
  String Address = "";
  User _user = User();
  bool is_data = false;
  Laundry_Owner _laundry = Laundry_Owner();
  Future<int>_get_user_Data()async{
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(
      K_API_Initial_Address+"users/getUserById",
      headers: headers,
      body: json.encode({
        "user_id" : widget.user_id,
      }),
    );
    var data = json.decode(response.body);
    // print("Data = $data");
    // MyToast(msg:"Data = $data");
    if(response.statusCode==200)
    {
      _user.mobile_no = data['user']['mobile_no'];
      _user.email = data['user']['email'];
      _user.first_name = data['user']['first_name'];
      _user.last_name = data['user']['last_name'];
      _user.city = data['user']['address']['city'];
      _user.state = data['user']['address']['state'];
      _user.street_address = data['user']['address']['street_address'];
      _user.country= data['user']['address']['country'];
      if(data['user']['role']==2)
      {
        _laundry.laundry_name = data['user']['address']['laundry_name'];
        _laundry.is_home_delivery = data['user']['address']['is_home_delivery'];
        _laundry.laundry_type = data['user']['address']['laundry_type'];
        _user.longitude = double.parse(data['user']['address']['longitude']);
        _user.latitude = double.parse(data['user']['address']['latitude']);
        LatLng adrs = LatLng(_user.latitude, _user.longitude);
        Placemark place =await  PlaceLocation.GetAddressFromLatLng(adrs);
        if(place.subLocality != null)
          Address =  "${place.subLocality},  ${place.locality} ${place.country}";
        else
          Address =  "${place.locality} ${place.country}";
      }
      setState(() {
        is_data = true;
      });
      return 1;
    }
    else
      return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Laundry Profile",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          is_data?
          IconButton(
            icon: Icon(Icons.rate_review,color: Colors.white,),
            tooltip: "Reviews and Ratings",
            onPressed: (){
              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_laundry_Owner_Rating_Reviews(laundry_owner_id: widget.user_id,Customer_Name: user.first_name+" "+user.last_name,)));
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_laundry_Owner_Rating_Reviews(laundry_owner_id: widget.user_id,)));
            },
          ):SizedBox(),
          IconButton(
            icon: Icon(Icons.description,color: Colors.white,),
            tooltip: "services",
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_Service_Details(user_id: widget.user_id,is_delivery: _laundry.is_home_delivery,)));
            },
          ),
          IconButton(
            tooltip: "Location",
            icon: Icon(Icons.location_on,color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Laundry_Owner_Location(Address: Address,lat: _user.latitude,lng: _user.longitude,)));
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: FutureBuilder(
            future: _get_user_Data(),
            builder:(context, Snap_data) {
              print("Snap Data = ${Snap_data.hasData}");
              if(Snap_data.hasData)
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue,width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //User Info
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Name:",style: mytextstyle(title_font,title_color ,FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  "${_user.first_name} ${_user.last_name}",
                                  style: mytextstyle(content_font, content_color,FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Mobile No:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _user.mobile_no.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Email:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _user.email.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Street Address:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _user.street_address.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("City:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _user.city.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("State:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _user.state.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Country:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _user.country.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                          // Laundry owner Info
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Laundry Name:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _laundry.laundry_name,
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Laundry Type:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _laundry.laundry_type,
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Delivery Service:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  _laundry.is_home_delivery==1?
                                  "Yes"
                                      :"No",
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              else if(Snap_data.hasError)
              {
                print("Exception in FutureBuilder = ${Snap_data.error}");
                return Center(child: Text("${Snap_data.error}"),);
              }
              else
                return
                  Center(child: CircularProgressIndicator(strokeWidth: 5,backgroundColor: Colors.black87,));
            }
        ),
      ),
    );
  }
}
