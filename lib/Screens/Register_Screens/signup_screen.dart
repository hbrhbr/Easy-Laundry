import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:easy_laundry/Screens/Register_Screens/mobile_authentication_screen.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/countries_list.dart';
import 'package:easy_laundry/models/country_model.dart';
import 'package:easy_laundry/providers/OTP_Model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class SignUp_Page extends StatefulWidget {
  @override
  _SignUp_PageState createState() => _SignUp_PageState();
}

class _SignUp_PageState extends State<SignUp_Page> {

  TextEditingController Controller_first_name = TextEditingController();
  TextEditingController Controller_last_name = TextEditingController();
  TextEditingController Controller_country_name = TextEditingController();
  TextEditingController Controller_mobile_number = TextEditingController();
  TextEditingController Controller_email = TextEditingController();
  FocusNode Focus_Node_email;
  FocusNode Focus_Node_first_name;
  FocusNode Focus_Node_last_name;
  FocusNode Focus_Node_country_name;
  FocusNode Focus_Node_mobile_number;
  String email_error_text = "";
  bool is_email_validate_error = false;
  bool is_first_name = false;
  bool is_last_name = false;
  bool is_country = false;
  bool is_mobile_number = false;
  List<Country> country_list = [];
  String country_code = "";
  String _isoCode = "";
  String number_error_text = "";
  TwilioFlutter twilioFlutter;

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
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    _check_Permission();
    _validate_Phone();
    Focus_Node_email = FocusNode();
    Focus_Node_country_name = FocusNode();
    Focus_Node_first_name = FocusNode();
    Focus_Node_last_name = FocusNode();
    Focus_Node_mobile_number = FocusNode();
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
    otp_provider = Provider.of<Flutter_Otp>(context);
    var user_provider = Provider.of<user_model>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.90,
                child: ListView(
                  children: <Widget>[
                    Image.asset(
                      "images/logo.png",
                      height: 150,
                    ),
                    // User First and Last Name
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
                                _email_validate(value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Country Name
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
                                RegExp("^[A-Za-z ]*"),
                              )
                            ],
                            controller: Controller_country_name,
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
                                labelText: "Country",
                                errorText: !is_country ? null : "*required",
                                errorStyle: TextStyle(fontSize: 15),
                                labelStyle:
                                    TextStyle(color: Colors.blueAccent)),
                            focusNode: Focus_Node_country_name,
                            onFieldSubmitted: (value) {
                              Focus_Node_country_name.unfocus();
                              if (Controller_country_name.text.isEmpty) {
                                setState(() {
                                  is_country = true;
                                });
                                Focus_Node_country_name.requestFocus();
                              } else {
                                String country_text =
                                    Controller_country_name.text.toLowerCase();
                                country_text = country_text.replaceRange(0, 1,
                                    country_text.substring(0, 1).toUpperCase());
                                Controller_country_name.text = country_text;
                                List<Country> a = country_list
                                    .where((country) =>
                                        country.name == country_text.trim())
                                    .toList();
                                if (a.isNotEmpty) {
                                  setState(() {
                                    country_code = "${a[0].dialCode}  ";
                                    _isoCode = "${a[0].countryCode}";
                                    user.user_country_iso_code = _isoCode;
                                    is_country = false;
                                    Focus_Node_mobile_number.requestFocus();
                                  });
                                } else {
                                  is_country = false;
                                  MyToast(
                                      msg: "Please Entr Valid Country Name");
                                  Focus_Node_country_name.requestFocus();
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
//                            inputFormatters: ,
                            controller: Controller_mobile_number,
                            toolbarOptions: ToolbarOptions(
                                cut: true, paste: true, selectAll: true),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefixStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                prefixText:
                                    country_code != "" ? country_code : "",
//                                prefix: country_code!=""?Row(
//                                  children: <Widget>[
//                                    Text(country_code)
//                                  ],
//                                ):null,
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                labelText: "Mobile Number",
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
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
                          if(!is_email_checked)
                          {
                           await _email_validate(Controller_email.text);
                          }
                        }
                        else if (Controller_country_name.text.isEmpty) {
                          setState(() {
                            is_country = true;
                            Focus_Node_country_name.requestFocus();
                          });
                          MyToast(msg: "Please Enter Country Name");
                          return;
                        } else if (Controller_mobile_number.text.isEmpty) {
                          setState(() {
                            is_mobile_number = true;
                            Focus_Node_mobile_number.requestFocus();
                          });
                          MyToast(msg: "Please Enter Mobile Number");
                          return;
                        }

                        user_provider.set_user_country_name(
                            Controller_country_name.text);
                        user_provider.set_user_country_code(country_code);
                        user_provider.set_user_email(Controller_email.text);
                        user_provider.set_user_name(Controller_first_name.text, Controller_last_name.text);
                        user_provider
                            .set_user_phone(Controller_mobile_number.text);
                        send_MSg();
                      },
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> send_MSg() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white10,
            content: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.black87,
                  strokeWidth: 6,
                ),
                SizedBox(width: 20,),
                Expanded(child: Text("Sending OTP"))
              ],
            )));
    try {
      int otp = 1000 + Random().nextInt(9999 - 1000);
      otp_provider.set_otp(otp);
      print("Otp = ${otp_provider.otp}");
        twilioFlutter.sendSMS(
            toNumber: "${country_code}".trim()+"${Controller_mobile_number.text}".trim(),
            messageBody: 'EasyLaundry Verification Code is $otp');
      await Future.delayed(Duration(seconds: 3));
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Mobile_Authentication_Page()));
    } catch (e) {
      print("Error While Sending OTP = $e");
      MyToast(msg: "Message sending Error = $e");
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
                  backgroundColor: Colors.black87,
                  strokeWidth: 6,
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
        Focus_Node_country_name.requestFocus() ;
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
