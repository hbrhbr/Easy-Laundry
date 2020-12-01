import 'dart:convert';

import 'package:easy_laundry/Screens/Home_Screen.dart';
import 'package:easy_laundry/Screens/profile_screens/update_profile.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/User_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class view_profile extends StatefulWidget {
  @override
  _view_profileState createState() => _view_profileState();
}


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
    "user_id" : user.user_id,
    }),
    );
    var data = json.decode(response.body);
    print("Data = $data");
    // MyToast(msg:"Data = $data");
    if(response.statusCode==200)
      {
        user.mobile_no = data['user']['mobile_no'];
        user.email = data['user']['email'];
        user.first_name = data['user']['first_name'];
        user.last_name = data['user']['last_name'];
        user.city = data['user']['address']['city'];
        user.state = data['user']['address']['state'];
        user.street_address = data['user']['address']['street_address'];
        user.country= data['user']['address']['country'];
        if(data['user']['role']==2)
             {
               laundry.laundry_name = data['user']['address']['laundry_name'];
               laundry.user_cnic = int.parse(data['user']['address']['cnic_no']);
               laundry.is_home_delivery = data['user']['address']['is_home_delivery'];
               laundry.laundry_type = data['user']['address']['laundry_type'];
               laundry.is_tax_filer = data['user']['address']['is_tax_filer'];
               // MyToast(msg: "Here = ${int.parse(data['user']['address']['ntn_no'])}");
               if(data['user']['address']['ntn_no']!="null")
                   laundry.ntn_no = int.parse(data['user']['address']['ntn_no']);
               else
                 laundry.ntn_no = null;

             }
        return 1;
      }
    else
      return null;
  }

class _view_profileState extends State<view_profile> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            user.role==2?"Laundry Owner Profile"
                :"Customer Profile"
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit,color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Update_Profile()));
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: ()async{
          return Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Home_Screen()));
        },
        child: FutureBuilder(
            future: _get_user_Data(),
            builder:(context, Snap_data) {
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
                                  "${user.first_name} ${user.last_name}",
                                  style: mytextstyle(content_font, content_color,FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                laundry.user_cnic!=null?Text("Cnic:",style: mytextstyle(title_font, title_color,FontWeight.bold),):SizedBox(),
                                SizedBox(width:laundry.user_cnic!=null? 5:0,),
                                laundry.user_cnic!=null?Text(
                                  laundry.user_cnic.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ):SizedBox(),
                                SizedBox(height: 10,),
                                Text("Mobile No:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  user.mobile_no.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Email:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  user.email.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Street Address:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  user.street_address.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("City:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  user.city.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("State:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  user.state.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Country:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  user.country.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                              ],

                            ),
                          ),
                          // Laundry owner Info
                          user.role==2?Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Laundry Name:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  laundry.laundry_name,
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Laundry Type:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  laundry.laundry_type,
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                laundry.ntn_no!=null?Text("NTN No:",style: mytextstyle(title_font,title_color, FontWeight.bold),):SizedBox(),
                                SizedBox(width: laundry.ntn_no!=null?5:0,),
                                laundry.ntn_no!=null?Text(
                                  laundry.ntn_no.toString(),
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ):SizedBox(),
                                SizedBox(height: 10,),
                                Text("Tax Payer:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  laundry.is_tax_filer==1?
                                    "Yes"
                                   :"No",
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                Text("Delivery Service:",style: mytextstyle(title_font,title_color, FontWeight.bold),),
                                SizedBox(width: 5,),
                                Text(
                                  laundry.is_home_delivery==1?
                                    "Yes"
                                   :"No",
                                  style: mytextstyle(content_font,content_color, FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ):SizedBox(),
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
                    Center(child: CircularProgressIndicator(strokeWidth: 5,backgroundColor: Colors.blueGrey,));
            }
        ),
      ),
    );
  }
}
