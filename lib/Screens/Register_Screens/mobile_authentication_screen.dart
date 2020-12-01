import 'dart:async';
import 'dart:math';
import 'package:easy_laundry/Screens/Register_Screens/selection_user_type_Screen.dart';
import 'package:easy_laundry/Screens/Register_Screens/signup_screen.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/User_model.dart';
import 'package:easy_laundry/providers/OTP_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

// ignore: camel_case_types
class Mobile_Authentication_Page extends StatefulWidget {
  String mbNumber;
  String country_code;
  Mobile_Authentication_Page({this.mbNumber,this.country_code});
  @override
  _Mobile_Authentication_PageState createState() =>
      _Mobile_Authentication_PageState();
}

// ignore: camel_case_types
class _Mobile_Authentication_PageState
    extends State<Mobile_Authentication_Page> {
  // ignore: non_constant_identifier_names
  bool is_code_timeout = false;
  // ignore: non_constant_identifier_names
  int time_remaining = 30;
  Timer _timer;
  bool is_verified = false;
  MaterialColor _pin_Color = Colors.blue;
  TwilioFlutter twilioFlutter;

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
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    startTimer();
    super.initState();
  }
  // Future<bool> _onWillPop() async {
  //   return Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>SignUp_Page()));
  // }
  @override
  Widget build(BuildContext context) {
    var otp_provider = Provider.of<Flutter_Otp>(context);
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
                  Center(
                    child: Text(
                      "Enter 4-digit Authentication Code",
                      style: TextStyle(fontSize: 20),
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
                        print("Otp = ${otp_provider.otp}");
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
                      ? SizedBox()
                      : is_code_timeout
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        color: Color(0xFF3698CF),
                        onPressed: () async {
                          try {
                            int otp = 1000 + Random().nextInt(9999 - 1000);
                            otp_provider.set_otp(otp);
                            twilioFlutter.sendSMS(
                                toNumber: "${user.mobile_no}",
                                messageBody: 'EasyLaundry Verification Code is $otp');
                            await Future.delayed(Duration(seconds: 3));
                            // Navigator.pop(context);
                            setState(() {
                              is_code_timeout = false;
                              startTimer();
                            });
                            _pinEditingController.clear();
                          } catch (e) {
                            print("Error While Sending OTP = $e");
                            MyToast(msg: "Msg not send");
                          }
                        },
                        child: Text(
                          "Resend Code",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  )
                      : Text("Resend Code in $time_remaining seconds"),
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
                        user_provider.set_user_phone("${user.user_country_code}".trim()+"${user.mobile_no}".trim());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext) => User_Type_Screen()));
                      } else {
                        MyToast(
                            msg: "Please Enter corrext OTP sent to your Number");
                      }
                    },
                    child: Center(
                      child: Text(
                        "Activate Account",
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
}




