import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_laundry/Screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/providers/Location_Model.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Laundry_details extends StatefulWidget {
  @override
  _Laundry_detailsState createState() => _Laundry_detailsState();
}

class _Laundry_detailsState extends State<Laundry_details> {
  TextEditingController Controller_Laundry_Name = TextEditingController();
  TextEditingController Controller_CNIC = TextEditingController();
  TextEditingController Controller_NTN = TextEditingController();
  String _laundry_type;
  List<String> _Display_Method = ["Registered", "Un-Registered"];

  bool is_cnic = false;
  bool is_ntn = false;
  File CNIC_IMg_front = null;
  File CNIC_IMg_back = null;
  FocusNode Focus_Node_Laundry_Name;
  FocusNode Focus_Node_NTN;
  FocusNode Focus_Node_CNIC;

  bool is_name = false;
  bool is_type = false;
  bool is_tax_payer = false;
  bool is_delivery_services = false;
  Location_Model Location_Data;



  @override
  void initState() {
    Focus_Node_Laundry_Name = FocusNode();
    Focus_Node_CNIC = FocusNode();
    Focus_Node_NTN = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user_provider = Provider.of<user_model>(context);
    Location_Data = Provider.of<Location_Model>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Laundry Details"),
      ),
      body: WillPopScope(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              //Laundry Name
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
                            RegExp("^[A-Z a-z]*"))
                      ],
                      controller: Controller_Laundry_Name,
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
                          labelText: "Laundry Name",
                          errorText: is_name ? "*required" : null,
                          errorStyle: TextStyle(fontSize: 15),
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                      focusNode: Focus_Node_Laundry_Name,
                      onFieldSubmitted: (value) {
                        if (Controller_Laundry_Name.text.isEmpty) {
                          setState(() {
                            is_name = true;
                          });
                        } else {
                          setState(() {
                            Focus_Node_Laundry_Name.unfocus();
                            is_name = false;
                          });

                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Laundry Type
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Laundry Type",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    RadioGroup<String>.builder(
                      direction: Axis.horizontal,
                      groupValue: _laundry_type,
                      onChanged: (value) => setState(() {
                        _laundry_type = value;
                      }),
                      items: _Display_Method,
                      itemBuilder: (item) =>
                          RadioButtonBuilder(
                            item,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Tax Payer CheckBox
              InkWell(
                onTap: (){
                  setState(() {
                    is_tax_payer = !is_tax_payer;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tax Payer",
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                      Checkbox(
                          value: is_tax_payer,
                          activeColor: Colors.blue,
                          checkColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              is_tax_payer = !is_tax_payer;
                            });
                          })
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Delivey Services CheckBox
              InkWell(
                onTap: (){
                  setState(() {
                    is_delivery_services = !is_delivery_services;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Service",
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                      Checkbox(
                          value: is_delivery_services,
                          activeColor: Colors.blue,
                          checkColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              is_delivery_services = !is_delivery_services;
                            });
                          })
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              //NTN Number
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
                      controller: Controller_NTN,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("^[0-9]*"))
                      ],
                      toolbarOptions: ToolbarOptions(
                          cut: true, paste: true, selectAll: true),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          labelText: "NTN Number (Optional)",
                          errorText: is_ntn ? "Enter valid NTN Number" : null,
                          errorStyle: TextStyle(fontSize: 15),
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                      focusNode: Focus_Node_NTN,
                      onFieldSubmitted: (value) {
                        Focus_Node_NTN.unfocus();
                        if (Controller_NTN.text.isNotEmpty &&
                            Controller_NTN.text.length < 8) {
                          setState(() {
                            is_ntn = true;
                          });
                          Focus_Node_NTN.requestFocus();
                        } else {
                          setState(() {
                            is_ntn = false;
                            Focus_Node_CNIC.requestFocus();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              //CNIC Number
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
                      controller: Controller_CNIC,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("^[0-9]{0,13}"))
                      ],
                      toolbarOptions: ToolbarOptions(
                          cut: true, paste: true, selectAll: true),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          labelText: "CNIC (03000********)",
                          errorText: is_cnic ? "Enter valid CNIC Number" : null,
                          errorStyle: TextStyle(fontSize: 15),
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                      focusNode: Focus_Node_CNIC,
                      onFieldSubmitted: (value) {
                        Focus_Node_CNIC.unfocus();
                        if (Controller_CNIC.text.isNotEmpty &&
                            Controller_CNIC.text.length < 13) {
                          setState(() {
                            is_cnic = true;
                          });
                          Focus_Node_CNIC.requestFocus();
                        } else {
                          setState(() {
                            is_cnic = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //CNIC Image_Front
              Container(
                padding: EdgeInsets.all(5),
                // height: 120,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: (){
                    getImage(1);

                  },
                  child: CNIC_IMg_front == null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 5),
                      Text("Upload CNIC Front Picture",
                          style: TextStyle(
                              color: Colors.blue, fontSize: 20)),
                    ],
                  )
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        CNIC_IMg_front,
                        fit: BoxFit.scaleDown,
                      )),
                ),
              ),
              SizedBox(height:10,),
              //CNIC Image_Back
              Container(
                padding: EdgeInsets.all(5),
                // height: 120,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () async{
                    getImage(2);
                  },
                  child: CNIC_IMg_back == null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 5),
                      Text("Upload CNIC Back Picture",
                          style: TextStyle(
                              color: Colors.blue, fontSize: 20)),
                    ],
                  )
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        CNIC_IMg_back,
                        fit: BoxFit.scaleDown,
                      )),
                ),
              ),
              SizedBox(height: 30),
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
                        if (Controller_Laundry_Name.text.isEmpty) {
                          MyToast(msg: "Please Enter Laundry Name");
                          Focus_Node_Laundry_Name.requestFocus();
                          return;
                        }
                        if (Controller_CNIC.text.isEmpty) {
                          MyToast(msg: "Please Enter CNIC");
                          Focus_Node_CNIC.requestFocus();
                          return;
                        }
                        if (CNIC_IMg_front == null) {
                          MyToast(msg: "Please Upload your CNIC Front image");
                          return;
                        }
                        if (CNIC_IMg_back == null) {
                          MyToast(msg: "Please Upload your CNIC Back image");
                          return;
                        }
                        user_provider.set_Ntn(Controller_NTN.text.isEmpty?null:int.parse(Controller_NTN.text));
                        String Img1 = base64Encode(CNIC_IMg_front.readAsBytesSync());
                        String Img2 = base64Encode(CNIC_IMg_back.readAsBytesSync());
                        user_provider.set_laundry_delivery(is_delivery_services?1:0);
                        user_provider.set_laundry_taxpayer(is_tax_payer?1:0);
                        user_provider.set_Cnic(Img1 , int.parse(Controller_CNIC.text),Img2);
                        _Register();
                      },
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:10),
            ],
          ),
      )
    );
  }

  Future<bool> getImage(int i) async {
    var img = null;
    try {
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print(e);
      MyToast(msg: "Failed to Pick Image");
      return img;
    }
    if(img!=null)
      {
          if(i==1)
          {
            print(img);
            setState(() {
              CNIC_IMg_front = img;
            });
          }
          if(i==2)
          {
            print(img);
            setState(() {
              CNIC_IMg_back = img;
            });
          }
      }
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
                  "Sending Request...\nPlease wait...",
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
                  "role" : user.role,
                  "first_name" : user.first_name,
                  "last_name" : user.last_name,
                  "email": user.email,
                  "mobile_no": user.mobile_no,
                  "password": user.password,
                  "username": ""
                },
                "address": {
                  "cnic_no":Controller_CNIC.text,
                  "laundry_type":_laundry_type,
                  "cnic_front":laundry.CNIC_Image_front,
                  "cnic_front_filename":CNIC_IMg_front.path.split('/').last,
                  "cnic_back_file_name":CNIC_IMg_back.path.split('/').last,
                  "cnic_back":laundry.CNIC_Image_back,
                  "city": user.city,
                  "laundry_name": Controller_Laundry_Name.text,
                  "ntn_no": laundry.ntn_no.toString(),
                  "is_tax_filer": laundry.is_tax_filer,
                  "state" : user.state,
                  "street_address": user.street_address,
                  "is_home_delivery" : laundry.is_home_delivery ,
                  "country": user.country,
                  "latitude": user.latitude.toString(),
                  "longitude": user.longitude.toString(),
                }
              }
          ));
      print(json.decode(response.body));
      if(response.statusCode==200)
      {
        MyToast(msg: "Laundry Request sent Successfully");
        Location_Data.clearLocation();
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => Login_Page()));
        MyToast(msg: "Please wait! Admin will send you account Activation mail");

      }
      else
      {
        MyToast(msg: "Failed to Register");
        Navigator.pop(context);
      }
    }catch(e)
    {
      print("Exception = $e");
      MyToast(msg: "Exception occur while sending request");
      Navigator.pop(context);
    }
  }
}
