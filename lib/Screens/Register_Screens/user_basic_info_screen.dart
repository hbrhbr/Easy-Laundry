import 'dart:convert';
import 'package:easy_laundry/Screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:easy_laundry/Add_User_Location.dart';
import 'package:easy_laundry/Screens/Laundry_owner_Screens/laundry_details.dart';

import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/providers/Location_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class User_basic_info_Page extends StatefulWidget {
  @override
  _User_basic_info_PageState createState() =>
      _User_basic_info_PageState();
}

class _User_basic_info_PageState
    extends State<User_basic_info_Page> {
  TextEditingController Controller_Street_Address = TextEditingController();
  TextEditingController Controller_City_Address = TextEditingController();
  TextEditingController Controller_State_Address = TextEditingController();
  TextEditingController Controller_Password = TextEditingController();
  TextEditingController Controller_Confrim_Password = TextEditingController();

  Location_Model Location_Data;
  user_model user_provider;
  double location_Btn_font_Size = 20;
  Color location_Btn_Color = Colors.white;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition;
  String _currentAddress;
  FocusNode Focus_Node_password;
  FocusNode Focus_Node_confirm_password;

  bool is_password = false;
  bool is_hide_password = true;
  bool is_confirm_password = false;
  FocusNode Focus_Node_Street_Address;
  FocusNode Focus_Node_State;
  FocusNode Focus_Node_City;



  void initState() {
    Focus_Node_password = FocusNode();
    Focus_Node_confirm_password = FocusNode();
    Focus_Node_Street_Address = FocusNode();
    Focus_Node_State = FocusNode();
    Focus_Node_City = FocusNode();
    super.initState();
  }

  Future<bool>_onwillpop()async{
    Location_Data.clearLocation();
    return true;
  }


  @override
  Widget build(BuildContext context) {
    user_provider = Provider.of<user_model>(context);
    Location_Data = Provider.of<Location_Model>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            user.role==2?
            "Laundry Owner Basic Information"
            :"Customer Basic Information"
        ),
      ),
      body: WillPopScope(
        onWillPop: _onwillpop,
        child: SingleChildScrollView(
          child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.87,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  //User Password
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        TextFormField(
                          obscureText: is_hide_password,
                          controller: Controller_Password,
                          toolbarOptions: ToolbarOptions(
                              cut: true, paste: true, selectAll: true),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                child: is_hide_password
                                    ? Icon(Icons.remove_red_eye)
                                    : Icon(
                                        Icons.visibility_off,
                                      ),
                                onTap: () {
                                  setState(() {
                                    is_hide_password = !is_hide_password;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              labelText: "Password",
                              errorText: !is_password ? null : "*required",
                              errorStyle: TextStyle(fontSize: 15),
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          focusNode: Focus_Node_password,
                          onFieldSubmitted: (value) {
                            Focus_Node_password.unfocus();
                            if (Controller_Password.text.isEmpty) {
                              setState(() {
                                is_password = true;
                              });
                              Focus_Node_password.requestFocus();
                            } else if (Controller_Password.text.length < 8) {
                              MyToast(
                                  msg:
                                      "Password should contain minimum 8 characters");
                              Focus_Node_password.requestFocus();
                            } else {
                              setState(() {
                                is_password = false;
                              });
                              Focus_Node_confirm_password.requestFocus();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Confrim Password
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        TextFormField(
                          obscureText: is_hide_password,
                          controller: Controller_Confrim_Password,
                          toolbarOptions: ToolbarOptions(
                              cut: true, paste: true, selectAll: true),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              labelText: "Confrim Password",
                              errorText:
                                  !is_confirm_password ? null : "*required",
                              errorStyle: TextStyle(fontSize: 15),
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          focusNode: Focus_Node_confirm_password,
                          onFieldSubmitted: (value) {
                            Focus_Node_confirm_password.unfocus();
                            if (Controller_Confrim_Password.text.isEmpty) {
                              setState(() {
                                is_confirm_password = true;
                              });
                              Focus_Node_confirm_password.requestFocus();
                            } else if (Controller_Confrim_Password.text !=
                                Controller_Password.text) {
                              MyToast(msg: "Please Enter same password");
                              Focus_Node_confirm_password.requestFocus();
                            } else {
                              setState(() {
                                is_confirm_password = false;
                              });
                              Focus_Node_Street_Address.requestFocus();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Street Adress
                  Container(
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
                                RegExp('^[0-9 A-Z a-z , #]*'))
                          ],
                          controller: Controller_Street_Address,
                          toolbarOptions: ToolbarOptions(
                              cut: true, paste: true, selectAll: true),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              labelText: "Street Address",
                              errorStyle: TextStyle(fontSize: 15),
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          focusNode: Focus_Node_Street_Address,
                          onFieldSubmitted: (value) {
                            Focus_Node_Street_Address.unfocus();
                            Focus_Node_City.requestFocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  //City
                  Container(
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
                                RegExp('^[A-Z a-z]*'))
                          ],
                          controller: Controller_City_Address,
                          toolbarOptions: ToolbarOptions(
                              cut: true, paste: true, selectAll: true),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              labelText: "City",
                              errorStyle: TextStyle(fontSize: 15),
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          focusNode: Focus_Node_City,
                          onFieldSubmitted: (value) {
                            Focus_Node_City.unfocus();
                            Focus_Node_State.requestFocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  //State
                  Container(
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
                                RegExp('^[A-Z a-z]*'))
                          ],
                          controller: Controller_State_Address,
                          toolbarOptions: ToolbarOptions(
                              cut: true, paste: true, selectAll: true),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              labelText: "State",
                              errorStyle: TextStyle(fontSize: 15),
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                          focusNode: Focus_Node_State,
                          onFieldSubmitted: (value) {
                            Focus_Node_State.unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  //Add/Edit Location Button
                  user.role==2?
                  Container(
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: primary_color,
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      onPressed: !Location_Data.is_Location
                          ? () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext) => MyOwnMap(address: "",init_map_Postion: null,is_drawer: false,)));
                        if (Location_Data.is_Location) {
                          setState(() {
                            location_Btn_Color = Colors.white;
                            location_Btn_font_Size = 20;
                          });
                        }
                      }
                          : () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext) => MyOwnMap(
                                  address: Location_Data.User_Address,
                                  is_drawer: false,
                                  init_map_Postion:
                                  Location_Data.user_Location,
                                )));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: !Location_Data.is_Location
                                ? <Widget>[
                              Icon(
                                Icons.add,
                                color: location_Btn_Color,
                              ),
                              Text(
                                "Add Location",
                                style: TextStyle(
                                    color: location_Btn_Color,
                                    fontSize: location_Btn_font_Size),
                              ),
                            ]
                                : <Widget>[
                              Icon(
                                Icons.edit,
                                color: location_Btn_Color,
                              ),
                              Text(
                                "Edit Location",
                                style: TextStyle(
                                    color: location_Btn_Color,
                                    fontSize: location_Btn_font_Size),
                              ),
                            ],
                          )),
                    ),
                  ):SizedBox(),
                  SizedBox(height: 30),
                ],
              ),
            ),
            // Next Button
            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 60,
                  child: FlatButton(
                    color: primary_color,
                    onPressed: () {
                      if (Controller_Password.text.isEmpty) {
                        MyToast(msg: "Please Enter a Password");
                        Focus_Node_password.requestFocus();
                        return;
                      }
                      if (Controller_Confrim_Password.text.isEmpty) {
                        MyToast(msg: "Please Confirm your Password");
                        Focus_Node_confirm_password.requestFocus();
                        return;
                      }
                      if(Controller_Password.text!=Controller_Confrim_Password.text)
                        {
                          MyToast(msg: "Please Enter Same Password");
                          Focus_Node_confirm_password.requestFocus();
                          return;
                        }
                      if(Controller_Street_Address.text.isEmpty)
                        {
                          MyToast(msg: "Please Enter Street Address");
                          Focus_Node_Street_Address.requestFocus();
                          return;
                        }
                      if(Controller_City_Address.text.isEmpty)
                        {
                          MyToast(msg: "Please Enter City");
                          Focus_Node_City.requestFocus();
                          return;
                        }
                      if(Controller_State_Address.text.isEmpty)
                        {
                          MyToast(msg: "Please Enter State");
                          Focus_Node_State.requestFocus();
                          return;
                        }
                      user_provider.set_password(Controller_Password.text);
                      user_provider.set_user_street_address(Controller_State_Address.text.trim());
                      user_provider.set_user_city(Controller_City_Address.text.trim());
                      user_provider.set_user_state(Controller_State_Address.text.trim());
                      if(user.role==2)
                      {
                        if(Location_Data.is_Location)
                        user_provider.set_latlng(Location_Data.user_Location.latitude, Location_Data.user_Location.longitude);
                        else
                          {
                            MyToast(msg: "Please Add Location");
                            setState(() {
                              location_Btn_Color = Colors.red;
                            });
                            return;
                          }
                      }
                      if(user.role==2)
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => Laundry_details()));
                      }
                      else if(user.role==3)
                        {
                          _Register();
                        }
                    },
                    child: Center(
                      child: Text(
                        user.role==2?"Continue":"Register",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
  Future<void>_Register()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.black87,
                  strokeWidth: 6,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Registering...\nPlease wait...",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.none),
                ),
              ],
            )));
    try{
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      final response = await http.post(
          K_API_Initial_Address + "users/register",
          headers: headers,
          body:json.encode(
              {
                "user": {
                  "role" : user.role.toString(),
                  "first_name" : user.first_name,
                  "last_name" : user.last_name,
                  "email": user.email,
                  "mobile_no": user.mobile_no,
                  "password": user.password,
                  "username": ""
                },
                "address": {
                  "cnic_no":"",
                  "laundry_type":"",
                  "cnic_front":"",
                  "cnic_back":"",
                  "city": user.city,
                  "laundry_name": "",
                  "ntn_no": "",
                  "is_tax_filer": "",
                  "state" : user.state,
                  "street_address": user.street_address,
                  "is_home_delivery" : "",
                  "country": user.country,
                  "latitude": "",
                  "longitude": "",
                }
              }
          )
      );
      print("Response body = ${response.body}");
      if(response.statusCode==200)
        {
          MyToast(msg: "Registered as Customer Successfully");
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => Login_Page()));
        }
      else
        {
          MyToast(msg: "Failed to Register");
          Navigator.pop(context);
        }
    }catch(e)
    {
      print("Exception = $e");
    }
  }
}
