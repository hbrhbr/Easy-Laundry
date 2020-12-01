import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:easy_laundry/Screens/login_screen.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/providers/OTP_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

// ignore: camel_case_types
class User_Authentication_Page extends StatefulWidget {
  String mobile_no;

  User_Authentication_Page({this.mobile_no});
  @override
  _User_Authentication_PageState createState() =>
      _User_Authentication_PageState();
}

// ignore: camel_case_types
class _User_Authentication_PageState
    extends State<User_Authentication_Page> {
  // ignore: non_constant_identifier_names
  bool is_code_timeout = false;
  TwilioFlutter twilioFlutter;
  TextEditingController Controller_Password = TextEditingController();
  TextEditingController Controller_Confrim_Password = TextEditingController();
  TextEditingController Controller_mobile_no = TextEditingController();
  bool is_password = false;
  bool is_hide_password = true;
  bool is_confirm_password = false;
  bool is_mobile = false;
  FocusNode Focus_Node_Mobile_no;
  FocusNode Focus_Node_password;
  FocusNode Focus_Node_confirm_password;

  // ignore: non_constant_identifier_names
  int time_remaining = 30;
  Timer _timer = null;
  bool is_verified = false;
  MaterialColor _pin_Color = Colors.blue;

  TextEditingController _pinEditingController = TextEditingController();
  Duration oneSec = const Duration(seconds: 1);
  void startTimer() {
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (time_remaining < 1) {
            time_remaining = 59;
            is_code_timeout = true;
            timer.cancel();
          } else {
            time_remaining = time_remaining - 1;
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    if(_timer!=null)
      _timer.cancel();
    super.dispose();
  }

  Future<void> send_MSg() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.black87,
                  strokeWidth: 3,
                ),
                SizedBox(width: 20,),
                Expanded(child: Text("Sending OTP"))
              ],
            )));
    try {
      int otp = 1000 + Random().nextInt(9999 - 1000);
      otp_provider.set_otp(otp);
      twilioFlutter.sendSMS(
          toNumber: "${user.mobile_no}",
          messageBody: 'EasyLaundry Verification Code is $otp');

      await Future.delayed(Duration(seconds: 3));
        startTimer();
            Navigator.pop(context);
    } catch (e) {
      print("Error While Sending OTP = $e");
      MyToast(msg: "Message sending Error");
    }
    MyToast(msg: "I am here");
  }

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    Focus_Node_confirm_password = FocusNode();
    Focus_Node_password = FocusNode();
    Focus_Node_Mobile_no = FocusNode();
    Controller_mobile_no.text = widget.mobile_no;
    startTimer();
    super.initState();
  }

  Flutter_Otp otp_provider;
  @override
  Widget build(BuildContext context) {
    otp_provider = Provider.of<Flutter_Otp>(context);
    var user_provider = Provider.of<user_model>(context);
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  is_mobile?
                      Center(
                    child: Text(
                      "Enter 4-digit Authentication Code",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                      :Container(
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        TextFormField(
                          controller: Controller_mobile_no,
                          readOnly: true,
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
                              labelText: "OTP sent to this Mobile Number",
                              errorStyle: TextStyle(fontSize: 15),
                              labelStyle: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Pin

                  Container(
                    width: 250,
                    height: 55,
                    child: PinInputTextField(
                      pinLength: 4,
                      controller: _pinEditingController,
                      textInputAction: TextInputAction.go,
                      enabled: true,
                      decoration: BoxLooseDecoration(
                        strokeWidth: 2,
                        strokeColorBuilder:
                        PinListenColorBuilder(_pin_Color, _pin_Color[200]),
                      ),
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (pin) {
                        print("Pinr = $pin");
                        if (otp_provider.otp== (int.parse(pin))) {
                          print(
                              "Matched ");
                          setState(() {
                            is_verified = true;
                            is_code_timeout = true;
                            _pin_Color = Colors.green;
                          });
                        } else if (pin.length < 4) {
                          setState(() {
                            is_verified = false;
                            _pin_Color = Colors.blue;
                          });
                          print("Still Not Matched");
                        } else {
                          print("Mismatched");
                          setState(() {
                            _pin_Color = Colors.red;
                            _timer.cancel();
                            is_code_timeout = true;
                            time_remaining = 59;
                          });
                        }
                      },
                      enableInteractiveSelection: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  is_verified
                      ? Column(children: [
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
                                is_password = false;
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
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],)
                      : is_code_timeout
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        color: Color(0xFF3698CF),
                        onPressed: () async {
                          setState(() {
                            is_code_timeout = false;
                            startTimer();
                          });
                          try {
                            send_MSg();
                          } catch (e) {
                            print("Error While Sending OTP = $e");
                            MyToast(msg: "Msg not send");
                          }
                        },
                        child: Text(
                          "Resend Code",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ):Text("Resend Code in $time_remaining seconds"),
                  // Expanded(child: SizedBox()),
                ],
              ),
            ),
            // Expanded(child: SizedBox()),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 60,
                  child: FlatButton(
                    color: Color(0xFF3698CF),
                    onPressed: () {
                      if (is_verified) {
                        if(Controller_Password.text.isEmpty)
                          {
                            MyToast(msg: "Please Enter Password");
                            Focus_Node_password.requestFocus();
                            return;
                          }
                        if(Controller_Confrim_Password.text.isEmpty)
                          {
                            MyToast(msg: "Please Confirm Password");
                            Focus_Node_confirm_password.requestFocus();
                            return;
                          }
                        if(Controller_Password.text!=Controller_Confrim_Password.text)
                          {
                            MyToast(msg:"Please Enter Same Password");
                            Focus_Node_confirm_password.requestFocus();
                            return;
                          }
                        _Reset_Password();
                      } else {
                        MyToast(
                            msg: "Please Enter corrext OTP sent to your Number");
                      }
                    },
                    child: Center(
                      child: Text(
                        "Reset Password",
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
    );
  }
  Future<void>_Reset_Password()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.black87,
                  strokeWidth: 2,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Updating Password...\nPlease wait...",
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
          K_API_Initial_Address + "users/changePassword",
          headers: headers,
          body:json.encode(
              {
                "email":user.email,
                "password":Controller_Password.text,
              }
          )
      );
      print("Result = ${response.body}");
      print("Status_Code = ${response.statusCode}");
      if(response.statusCode==200)
      {
        MyToast(msg: "Password Updated Successfully");
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => Login_Page()));
      }
      else
      {
        MyToast(msg: "Failed to Update");
        Navigator.pop(context);
      }
    }catch(e)
    {
      print("Exception = $e");
      Navigator.pop(context);
      MyToast(msg: "Exception occured while updating password");
    }
  }

}