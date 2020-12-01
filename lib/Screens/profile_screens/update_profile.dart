import 'dart:convert';
import 'dart:math';

import 'package:easy_laundry/Screens/profile_screens/view_profile.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/countries_list.dart';
import 'package:easy_laundry/models/country_model.dart';
import 'package:easy_laundry/providers/OTP_Model.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'package:twilio_flutter/twilio_flutter.dart';
class Update_Profile extends StatefulWidget {
  @override
  _Update_ProfileState createState() => _Update_ProfileState();
}

class _Update_ProfileState extends State<Update_Profile> {
  TextEditingController Controller_first_name = TextEditingController();
  TextEditingController Controller_last_name = TextEditingController();
  TextEditingController Controller_mobile_number = TextEditingController();
  TextEditingController Controller_email = TextEditingController();
  TextEditingController Controller_Street_Address = TextEditingController();
  TextEditingController Controller_City_Address = TextEditingController();
  TextEditingController Controller_State_Address = TextEditingController();
  TextEditingController Controller_Laundry_Name = TextEditingController();
  TextEditingController Controller_NTN = TextEditingController();
  FocusNode Focus_Node_email;
  FocusNode Focus_Node_first_name;
  FocusNode Focus_Node_last_name;
  FocusNode Focus_Node_mobile_number;
  FocusNode Focus_Node_Street_Address;
  FocusNode Focus_Node_State;
  FocusNode Focus_Node_City;
  FocusNode Focus_Node_Laundry_Name;
  FocusNode Focus_Node_NTN;
  String email_error_text = "";
  bool is_email_validate_error = false;
  bool is_first_name = false;
  bool is_last_name = false;
  bool is_country = false;
  bool is_ntn = false;
  bool is_mobile_number = false;
  bool is_name = false;
  bool is_type = false;
  bool is_tax_payer = false;
  bool is_delivery_services = false;
  List<Country> country_list = [];
  String country_code = "";
  String _isoCode = "";
  String number_error_text = "";
  TwilioFlutter twilioFlutter;
  String _laundry_type="";
  List<String> _Display_Method = ["Registered", "Un-Registered"];

  _check_Permission() async {
    bool is_sms_permission = await Permission.sms.isGranted;
    bool is_phone_permission = await Permission.phone.isGranted;
    bool is_location_permission = await Permission.locationAlways.isGranted;
    if (!is_sms_permission) {
      await Permission.sms.request();
    }
    if (!is_location_permission) {
      await Permission.locationAlways.request();
    }
    if (!is_phone_permission) {
      await Permission.phone.request();
    }

  }

  @override
  void initState() {

    List<Country> a = country_list
        .where((country) =>
    country.name == user.country.trim())
        .toList();
    if (a.isNotEmpty) {
        country_code = "${a[0].dialCode}  ";
        _isoCode = "${a[0].countryCode}";
        print("Iso Code = $_isoCode");
    }
    Controller_first_name.text = user.first_name;
    Controller_last_name.text = user.last_name;
    Controller_email.text = user.email;
    Controller_mobile_number.text = user.mobile_no;
    Controller_State_Address.text = user.state;
    Controller_City_Address.text = user.city;
    Controller_Street_Address.text = user.street_address;
    Controller_NTN.text = laundry.ntn_no!=null?laundry.ntn_no.toString():"";
    Controller_Laundry_Name.text = laundry.laundry_name;
    _laundry_type = laundry.laundry_type;
    is_tax_payer = laundry.is_tax_filer==1?true:false;
    is_delivery_services = laundry.is_home_delivery==1?true:false;
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    _check_Permission();
    _validate_Phone();
    Focus_Node_email = FocusNode();
    Focus_Node_first_name = FocusNode();
    Focus_Node_last_name = FocusNode();
    Focus_Node_mobile_number = FocusNode();
    Focus_Node_Street_Address = FocusNode();
    Focus_Node_State= FocusNode();
    Focus_Node_City= FocusNode();
    Focus_Node_Laundry_Name = FocusNode();
    Focus_Node_NTN = FocusNode();
    super.initState();
  }

  _validate_Phone() async {
    country_list = (Countries.countryList
        .map((country) => Country.fromJson(country))
        .toList());
  }

  Flutter_Otp otp_provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>view_profile()));
        },
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("^[A-Za-z ]*"))
                        ],
                        controller: Controller_first_name,
                        toolbarOptions: ToolbarOptions(
                            cut: true, paste: true, selectAll: true),
                        textInputAction: TextInputAction.next,
                        textCapitalization:
                        TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            labelText: "First Name",
                            errorText:
                            !is_first_name ? null : "*required",
                            errorStyle: TextStyle(fontSize: 15),
                            labelStyle:
                            TextStyle(color: Colors.blueAccent)),
                        focusNode: Focus_Node_first_name,
                        onFieldSubmitted: (value) {
                          Focus_Node_first_name.unfocus();

                          if (Controller_first_name.text.isEmpty) {
                            setState(() {
                              is_first_name = true;
                            });
                            Focus_Node_first_name.requestFocus();
                          } else {
                            Focus_Node_last_name.requestFocus();
                            setState(() {
                              is_first_name = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("^[A-Za-z ]*"))
                        ],
                        controller: Controller_last_name,
                        toolbarOptions: ToolbarOptions(
                            cut: true, paste: true, selectAll: true),
                        textInputAction: TextInputAction.next,
                        textCapitalization:
                        TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            labelText: "Last Name",
                            errorText:
                            !is_last_name ? null : "*required",
                            errorStyle: TextStyle(fontSize: 15),
                            labelStyle:
                            TextStyle(color: Colors.blueAccent)),
                        focusNode: Focus_Node_last_name,
                        onFieldSubmitted: (value) {
                          Focus_Node_last_name.unfocus();
                          if (Controller_last_name.text.isEmpty) {
                            Focus_Node_last_name.requestFocus();
                            setState(() {
                              is_last_name = true;
                            });
                          } else {
                            Focus_Node_email.requestFocus();
                            setState(() {
                              is_last_name = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //User Email
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
                    controller: Controller_email,
                    toolbarOptions: ToolbarOptions(
                        cut: true, paste: true, selectAll: true),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Email",
                        errorText: !is_email_validate_error
                            ? null
                            : email_error_text,
                        errorStyle: TextStyle(fontSize: 15),
                        labelStyle:
                        TextStyle(color: Colors.blueAccent)),
                    focusNode: Focus_Node_email,
                    onFieldSubmitted: (value) {
                      Focus_Node_email.unfocus();
                      if (Controller_email.text.isEmpty) {
                        setState(() {
                          is_email_validate_error = true;
                          email_error_text = "*required";
                        });
                        Focus_Node_email.requestFocus();
                      } else {
                        if(user.email!=value)
                          _email_validate(value);
                        else Focus_Node_mobile_number.requestFocus();
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //Mobile Number
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
                          RegExp("^[+][0-9]*"))
                    ],
                    controller: Controller_mobile_number,
                    toolbarOptions: ToolbarOptions(
                        cut: true, paste: true, selectAll: true),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixStyle: TextStyle(
                            color: Colors.black, fontSize: 18),
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: "Mobile Number( +xxxxxxxxxxx )",
                        errorText: !is_mobile_number
                            ? null
                            : number_error_text,
                        errorStyle: TextStyle(fontSize: 15),
                        labelStyle:
                        TextStyle(color: Colors.blueAccent)),
                    focusNode: Focus_Node_mobile_number,
                    onFieldSubmitted: (value) async {
                      Focus_Node_mobile_number.unfocus();
                      if (Controller_mobile_number.text.isEmpty) {
                        setState(() {
                          is_mobile_number = true;
                          number_error_text = "*required";
                          Focus_Node_mobile_number.requestFocus();
                        });
                      } else {
                        var a =
                        await PhoneNumberUtil.isValidPhoneNumber(
                            phoneNumber:
                            Controller_mobile_number.text,
                            isoCode: _isoCode);
                        if (!a) {
                          MyToast(
                              msg:
                              "Please Enter a valid Mobile Number");
                          is_mobile_number = true;
                          number_error_text =
                          "Enter Valid Mobile Number";
                          Focus_Node_mobile_number.requestFocus();
                        } else {
                          setState(() {
                            is_mobile_number = false;
                            Focus_Node_Street_Address.requestFocus();
                          });
                        }
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
                      Focus_Node_Laundry_Name.requestFocus();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            //Laundry Name
            user.role==2?
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
            ):SizedBox(),
            SizedBox(
              height: user.role==2?10:0,
            ),
            //Laundry Type
            user.role==2?
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
            ):SizedBox(),
            SizedBox(
              height: user.role==2?10:0,
            ),
            //Tax Payer CheckBox
            user.role==2?
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
            ):SizedBox(),
            SizedBox(
              height:user.role==2?10:0,
            ),
            //Delivey Services CheckBox
            user.role==2?
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
            ):SizedBox(),
            SizedBox(height: user.role==2?10:0),
            //NTN Number
            user.role==2?
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
                        });
                      }
                    },
                  ),
                ],
              ),
            ):SizedBox(),
            SizedBox(height: user.role==2?10:0),
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
                    onPressed: () async{
                      if (Controller_first_name.text.isEmpty) {
                        setState(() {
                          is_first_name = true;
                          Focus_Node_first_name.requestFocus();
                        });
                        MyToast(msg: "Please Enter First Name");
                        return;
                      } else if (Controller_last_name.text.isEmpty) {
                        setState(() {
                          is_last_name = true;
                          Focus_Node_last_name.requestFocus();
                        });
                        MyToast(msg: "Please Enter Last Name");
                        return;
                      } else if (Controller_email.text.isEmpty) {
                        setState(() {
                          is_email_validate_error = true;
                          Focus_Node_email.requestFocus();
                        });
                        MyToast(msg: "Please Enter Email");
                        return;
                      }
                      else if(Controller_email.text.isNotEmpty){
                        if(!is_email_checked && Controller_email.text!=user.email)
                        {
                          await _email_validate(Controller_email.text);
                        }
                      }
                       else if (Controller_mobile_number.text.isEmpty) {
                        setState(() {
                          is_mobile_number = true;
                          Focus_Node_mobile_number.requestFocus();
                        });
                        MyToast(msg: "Please Enter Mobile Number");
                        return;
                      }
                       else if(Controller_Street_Address.text.isEmpty){
                        setState(() {
                          Focus_Node_Street_Address.requestFocus();
                        });
                        MyToast(msg: "Please Enter Street Address");
                        return;
                      }
                       else if(Controller_City_Address.text.isEmpty){
                        setState(() {
                          Focus_Node_City.requestFocus();
                        });
                        MyToast(msg: "Please Enter City");
                        return;
                      }
                       else if(Controller_State_Address.text.isEmpty){
                        setState(() {
                          Focus_Node_State.requestFocus();
                        });
                        MyToast(msg: "Please Enter State");
                        return;
                      }
                       else if(Controller_Laundry_Name.text.isEmpty&&user.role==2){
                        setState(() {
                          Focus_Node_Laundry_Name.requestFocus();
                        });
                        MyToast(msg: "Please Enter Laundry Name");
                        return;
                      }
                       _Update_Prdofile();
                    },
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }


  Future<void>_Update_Prdofile()async{
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
                  strokeWidth: 6,
                  backgroundColor: Colors.black87,
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
          K_API_Initial_Address + "users/update",
          headers: headers,
          body:json.encode(
              {
                "user": {
                  "user_id":user.user_id,
                  "first_name" : Controller_first_name.text,
                  "last_name" : Controller_last_name.text,
                  "email": Controller_email.text,
                  "mobile_no": Controller_mobile_number.text,
                },
                "address": {
                  "laundry_type":_laundry_type,
                  "city": Controller_City_Address.text,
                  "laundry_name": Controller_Laundry_Name.text,
                  "ntn_no": Controller_NTN.text,
                  "is_tax_filer": is_tax_payer?1:0,
                  "state" : Controller_State_Address.text,
                  "street_address": Controller_Street_Address.text,
                  "is_home_delivery" : is_delivery_services?1:0,
                }
              }
          ));
      print(json.decode(response.body));
      if(response.statusCode==200)
      {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
        MyToast(msg: "Profile Updated Successfully");
        if(user.first_name.trim() == Controller_first_name.text.trim())
          {
            user.first_name = Controller_first_name.text;
          }
        if(user.last_name.trim() == Controller_last_name.text.trim())
          {
            user.last_name = Controller_last_name.text;
          }
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => view_profile()));
      }
      else
      {
        MyToast(msg: "Failed to Update");
        Navigator.pop(context);
      }
    }catch(e)
    {
      print("Exception = $e");
      // MyToast(msg: "Exception occur while sending request = $e");
      Navigator.pop(context);
    }
  }

  Future<bool>_is_already_exists()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white10,
            title: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: primary_color,
                  strokeWidth: 3,
                ),
                SizedBox(width: 20,),
                Expanded(child: Text("Checking Email"))
              ],
            )));
    try{
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      var response = await http.post(
        K_API_Initial_Address+"users/checkIfUserExist",
        headers: headers,
        body: json.encode({
          "email" : Controller_email.text.trim(),
        }),
      );
      if(response.body == "No User Found with this Email")
      {
        Navigator.pop(context);
        return true;
      }
      else {
        Navigator.pop(context);
        return false;}
    }catch(e){
      Navigator.pop(context);
      MyToast(msg: "Faild to check Email");
      print("Following Exception occur : $e");
      return false;
    }
  }
  bool  is_email_checked = false;
  _email_validate(String value) async{

    if (EmailValidator.validate(value)) {
      bool a = await _is_already_exists();
      if(a)
        setState(() {
          is_email_checked = true;
          is_email_validate_error = false;
          Focus_Node_mobile_number.requestFocus() ;
        });
      else{
        setState(() {
          is_email_validate_error = true;
          Focus_Node_email.requestFocus();
          email_error_text = "Email already exists";
        });
      }
    } else {
      setState(() {
        is_email_validate_error = true;
        Focus_Node_email.requestFocus();
        email_error_text = "Enter Valid Email";
      });
    }
  }
}
