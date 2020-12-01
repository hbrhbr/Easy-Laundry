import 'dart:convert';
import 'package:easy_laundry/Add_User_Location.dart';
import 'package:easy_laundry/Appointments_Screens/view_Customers_all_oappointments.dart';
import 'package:easy_laundry/Appointments_Screens/view_all_appointments_for_laundry_owner.dart';
import 'package:easy_laundry/Screens/Laundry_rating_screen.dart';
import 'package:easy_laundry/Screens/Orders_Screens/customer_view_all_orders.dart';
import 'package:easy_laundry/Screens/Orders_Screens/view_all_orders_for_laundry_owner.dart';
import 'package:easy_laundry/Screens/Change_Password.dart';
import 'package:easy_laundry/Screens/financial_details_screen.dart';
import 'package:easy_laundry/Screens/login_screen.dart';
import 'package:easy_laundry/Screens/profile_screens/view_profile.dart';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/Search_View_Laundry_Screens/Search_Laundry.dart';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/Service_Details_Screens/view_Service_details.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/countries_list.dart';
import 'package:easy_laundry/models/country_model.dart';
import 'package:easy_laundry/models/placeLocation.dart';
import 'package:easy_laundry/providers/Location_Model.dart';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/tax_percentage_Screens/add_tax_percentage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

const double Expasion_Child_left_Padd = 40;

// ignore: camel_case_types
class myDrawer extends StatefulWidget {
  @override
  _myDrawerState createState() => _myDrawerState();
}

// ignore: camel_case_types
class _myDrawerState extends State<myDrawer> {
  Location_Model LocationData;
  bool is_Loading= false;
  int selected;
  @override
  Widget build(BuildContext context) {
    LocationData = Provider.of<Location_Model>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Drawer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(

                children: <Widget>[
                  SizedBox(
                    height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("images/logo.png"),
                      Align(
                        alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,top: 10),
                            child: Container(
                              padding: EdgeInsets.only(top: 2,bottom: 2,left: 5,right: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue)
                              ),
                              child: Text(
                                user.role==2?
                                  "Laundry Owner"
                                  :"Customer",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue
                                ),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),),
                  Divider(),

                  myInkwell(
                    InkWell_Title: 'Profile',
                    InkWell_Icon: Icons.person,
                    onClick: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>view_profile()));
                    },
                  ),
                  // ExpansionTile(
                  //   leading: Icon(Icons.add_to_queue,color: Colors.grey,),
                  //   title: Text("Appointments",style: TextStyle(color: Colors.black54),),
                  //   children: [
                  //     Divider(color: Colors.grey,),
                  //     ListTile(
                  //       title: Text(
                  //         appointment_list[0].Appointment_status,
                  //         style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: SizedBox(width: 100,),
                  //       onTap: (){
                  //         user.role==3?
                  //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Appointments(cust_id: user.user_id,obj_status: status_list[0],)))
                  //             :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Appointments(laundry_owner_id: user.user_id,obj_status:appointment_list[0] ,)));
                  //       },
                  //     ),
                  //     Divider(color: Colors.grey,),
                  //     ListTile(
                  //       title: Text(
                  //         appointment_list[1].Appointment_status,
                  //         style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: SizedBox(width: 100,),
                  //       onTap: (){
                  //         user.role==3?
                  //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Appointments(cust_id: user.user_id,obj_status: status_list[1],)))
                  //             :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Appointments(laundry_owner_id: user.user_id,obj_status:appointment_list[1] ,)));
                  //       },
                  //     ),
                  //     Divider(color: Colors.grey,),
                  //     ListTile(
                  //       title: Text(
                  //         appointment_list[2].Appointment_status,
                  //         style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: SizedBox(width: 100,),
                  //       onTap: (){
                  //         user.role==3?
                  //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Appointments(cust_id: user.user_id,obj_status: status_list[2],)))
                  //             :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Appointments(laundry_owner_id: user.user_id,obj_status:appointment_list[2] ,)));
                  //       },
                  //     ),
                  //     Divider(color: Colors.grey,),
                  //     ListTile(
                  //       title: Text(
                  //         appointment_list[3].Appointment_status,
                  //         style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: SizedBox(width: 100,),
                  //       onTap: (){
                  //         user.role==3?
                  //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Appointments(cust_id: user.user_id,obj_status: status_list[3],)))
                  //             :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Appointments(laundry_owner_id: user.user_id,obj_status:appointment_list[3] ,)));
                  //       },
                  //     ),
                  //     Divider(color: Colors.grey,),
                  //     ListTile(
                  //       title: Text(
                  //         appointment_list[4].Appointment_status,
                  //         style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: SizedBox(width: 100,),
                  //       onTap: (){
                  //         user.role==3?
                  //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Appointments(cust_id: user.user_id,obj_status: status_list[4],)))
                  //             :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Appointments(laundry_owner_id: user.user_id,obj_status:appointment_list[4] ,)));
                  //       },
                  //     ),
                  //   ],
                  // ),
                  ExpansionTile(
                    leading: Icon(Icons.shopping_cart,color: Colors.grey,),
                    title: Text("Orders",style: TextStyle(color: Colors.black54),),
                    children: [
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[0].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[0],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[0] ,)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[1].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[1],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[1] ,)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[2].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[2],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[2] ,)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[3].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[3],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[3] ,)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[4].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[4],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[4] ,)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[5].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[5],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[5] ,)));
                        },
                      ),
                      Divider(color: Colors.grey,),
                      ListTile(
                        title: Text(
                          status_list[6].status,
                          style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
                        ),
                        leading: SizedBox(width: 100,),
                        onTap: (){
                          user.role==3?
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Customer_View_All_Orders(cust_id: user.user_id,obj_status: status_list[6],)))
                              :Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>laundry_View_All_customers_Orders(laundry_owner_id: user.user_id,obj_status:status_list[6] ,)));
                        },
                      ),
                    ],
                  ),
                  user.role==2?
                  myInkwell(
                    InkWell_Title: 'Service Details',
                    InkWell_Icon: Icons.description,
                    onClick: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_Service_Details(user_id:user.user_id)));
                    },
                  ):SizedBox(),
                  user.role==2?
                  myInkwell(
                    InkWell_Title: 'Location',
                    InkWell_Icon: Icons.location_on,
                    onClick: () async{
                      setState(() {
                        is_Loading=true;
                      });
                      String address = await _get_user_address();
                      if(address!="")
                        {
                          setState(() {
                            is_Loading=false;
                          });
                        }
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>
                                    MyOwnMap(
                                      address: address,
                                      is_drawer: true,
                                      init_map_Postion:LatLng(user.latitude, user.longitude),)));
                    },
                  ):SizedBox(),
                  myInkwell(
                    InkWell_Title: 'Financial Details',
                    InkWell_Icon: Icons.receipt,
                    onClick: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_Financial_Details()));
                    },
                  ),
                  user.role==3?
                  myInkwell(
                    InkWell_Title: 'Laundry',
                    InkWell_Icon: Icons.local_laundry_service,
                    onClick: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Search_Laundry()));
                    },
                  ):SizedBox(),
                  user.role==2?
                  myInkwell(
                    InkWell_Title: 'Tax Percentage',
                    InkWell_Icon: Icons.assessment,
                    onClick: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Add_View_Tax_Percentage()));
                    },
                  ):SizedBox(),
                  user.role==2?
                  myInkwell(
                    InkWell_Title: 'Rating & Reviews',
                    InkWell_Icon: Icons.rate_review,
                    onClick: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_laundry_Owner_Rating_Reviews(laundry_owner_id: user.user_id,Customer_Name: "Habib",)));
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_laundry_Owner_Rating_Reviews(laundry_owner_id: user.user_id,)));
                    },
                  ):SizedBox(),
                  myInkwell(
                    InkWell_Title: 'Change Password',
                    InkWell_Icon: Icons.vpn_key,
                    onClick: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Change_Password()));
                    },
                  ),
                  myInkwell(
                    InkWell_Title: 'Logout',
                    InkWell_Icon: Icons.exit_to_app,
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Do you want to Logout???"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("No"),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Login_Page()));
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        ),
                      );
                },
                  ),
                ],
              ),
            ),
            is_Loading
                ?Align(
              alignment: Alignment.center,
              child: Container(
                height: double.infinity,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 3,)),
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<String>_get_user_address()async{
    is_Loading=true;
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(
      K_API_Initial_Address+"users/getUserById",
      headers: headers,
      body: json.encode({
        "user_id" : user.user_id,
      }),
    );
    var data = json.decode(response.body);
    print("Data = $data");
    if(response.statusCode==200) {
      user.latitude = double.parse(data['user']['address']['latitude']);
      user.longitude = double.parse(data['user']['address']['longitude']);
      user.country = data['user']['address']['country'];
      List<Country>country_list = (Countries.countryList
          .map((country) => Country.fromJson(country))
          .toList());
      List<Country> a = country_list
          .where((country) =>
      country.name == user.country.trim())
          .toList();
      String country_code = "${a[0].dialCode}  ";
      user.user_country_iso_code = "${a[0].countryCode}";
      LatLng address = LatLng(user.latitude, user.longitude);
      Placemark place =await  PlaceLocation.GetAddressFromLatLng(address);
      if(place.subLocality != null)
        return    "${place.subLocality},  ${place.locality} ${place.country}";
      else
        return "${place.locality} ${place.country}";
    }
  }

}
// ignore: camel_case_types
class myInkwell extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final InkWell_Title;

  // ignore: non_constant_identifier_names
  final InkWell_Icon;

  // ignore: non_constant_identifier_names
  final InkWell_Icon_Color;
  final onClick;

  // ignore: non_constant_identifier_names
  myInkwell(
      {this.onClick,
        this.InkWell_Icon_Color,
        this.InkWell_Icon,
        this.InkWell_Title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: ListTile(
        title: Text(InkWell_Title,style: TextStyle(color: Colors.black54),),
        leading: Icon(
          InkWell_Icon,
          color: InkWell_Icon_Color,
        ),
      ),
    );
  }
}
