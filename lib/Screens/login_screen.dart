import 'dart:convert';
import 'dart:math';
import 'package:easy_laundry/Screens/Home_Screen.dart';
import 'package:easy_laundry/Screens/Register_Screens/signup_screen.dart';
import 'package:easy_laundry/Screens/forgot_password.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/order_model.dart';
import 'package:easy_laundry/providers/OTP_Model.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  TextEditingController Controller_email = TextEditingController();
  TextEditingController Controller_password = TextEditingController();
  FocusNode Focus_Node_email;
  FocusNode Focus_Node_password;
  bool is_email_validate = false;
  bool is_password_error = false;
  user_model user_provider;
  TwilioFlutter twilioFlutter;
  
  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    Focus_Node_email = FocusNode();
    Focus_Node_password = FocusNode();
    super.initState();
  }

  Future<bool> _onWillPop() async {
       return false;
  }

  Flutter_Otp otp_provider;

  @override
  Widget build(BuildContext context) {
    otp_provider = Provider.of<Flutter_Otp>(context);
    user_provider = Provider.of<user_model>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(height: 30,),
                    Image.asset("images/logo.png",height: 200,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          TextFormField(
                            controller: Controller_email,
                            toolbarOptions:
                                ToolbarOptions(cut: true, paste: true, selectAll: true),
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
                                labelText: "Enter Your Email",

                                labelStyle: TextStyle(color: Colors.blueAccent)),
                            focusNode: Focus_Node_email,
                            onFieldSubmitted: (value) {
                              Focus_Node_email.unfocus();
                              Focus_Node_password.requestFocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          TextFormField(
                            obscureText: true,
                            controller: Controller_password,
                            toolbarOptions:
                                ToolbarOptions(cut: true, paste: true, selectAll: true),
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
                                labelText: "Enter Password",
                                errorText: is_password_error &&
                                        Controller_password.text.isEmpty
                                    ? "Please enter your pasword"
                                    : null,
                                labelStyle: TextStyle(color: Colors.blueAccent)),
                            focusNode: Focus_Node_password,
                            onFieldSubmitted: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  is_password_error = true;
                                });
                              } else {
                                print(value);
                                setState(() {
                                  is_password_error = false;
                                });
                              }
                              Focus_Node_password.unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: ()async{
                              if(Controller_email.text.isEmpty)
                                {
                                  MyToast(msg: "Pleae Enter your Email");
                                  Focus_Node_email.requestFocus();
                                  return;
                                }
                              String mobile_no = await _get_mobile_number();
                              if(mobile_no!=""){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>User_Authentication_Page(mobile_no: mobile_no)));
                                Focus_Node_email.unfocus();
                                Focus_Node_password.unfocus();
                              }
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blue
                              ),
                            ),
                          ),
                          SizedBox(width:5,)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 60,
                      child: RaisedButton(
                        color: Color(0xFF3698CF),
                        onPressed: () {
                          if (Controller_email.text.isEmpty) {
                            MyToast(msg: "Please Enter your Email");
                            return;
                          }
                          if (Controller_password.text.isEmpty) {
                            MyToast(msg: "Please Enter your password");
                            return;
                          }
                          _login();
                        },
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 60,
                      child: RaisedButton(
                        color: Color(0xFF3698CF),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>SignUp_Page()));
                        },
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String>_get_mobile_number()async{
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
                Expanded(child: Text("Fetching details"))
              ],
            )));
    try{
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      var response = await http.post(
        K_API_Initial_Address+"users/findMobileNoByEmail",
        headers: headers,
        body: json.encode({
          "email" : Controller_email.text.trim(),
        }),
      );
      var data = json.decode(response.body);
      if(data['mobile_no'] != null)
      {
        user_provider.set_user_email(Controller_email.text);
        int otp = 1000 + Random().nextInt(9999 - 1000);
        otp_provider.set_otp(otp);
        twilioFlutter.sendSMS(
            toNumber: "${user.mobile_no}",
            messageBody: 'EasyLaundry Verification Code is $otp');
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context);
        return data['mobile_no'];
      }
      else {
        Navigator.pop(context);
        MyToast(msg: "${data['err_msg']}");
        return "";
      }
    }catch(e){
      Navigator.pop(context);
      MyToast(msg: "Faild to check Email");
      print("Following Exception occur : $e");
      return "";
    }
  }
  Future<void> _login() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.black87,
                  strokeWidth: 6,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Signing in...\nPlease wait...",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      decoration: TextDecoration.none),
                )
              ],
            )));
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
     final response =
     await http.post(K_API_Initial_Address + "users/login",
         headers: headers,
         body: json.encode(
             {
               "email": Controller_email.text,
               "password": Controller_password.text,
             }
         ));
      print("Responce = ${response.body}");
      if(response.body=="Incorrect Email or Password")
       {
         MyToast(msg: "Incorrect Email or Password");
         Navigator.pop(context);
         return;
       }
     else if (response.statusCode==200 ) {
       var datauser = json.decode(response.body);
       user_provider.set_user_email(datauser['email']);
       user.role = datauser['role']["role_id"];
      user.user_id = datauser["user_id"];
      user.first_name = datauser["first_name"];
      user.last_name = datauser["last_name"];
       Navigator.pop(context);
       Navigator.push(
           context,
           MaterialPageRoute(
             // ignore: non_constant_identifier_names
               builder: (BuildContext) => Home_Screen()));
     }
     else
     {
       MyToast(msg: "Failed to Sign in...\n Please try again");
       Navigator.pop(context);
     }
  }catch(e){
      print("Exceprion = $e");
      Navigator.pop(context);
      MyToast(msg: "Connection error! \n Failed to sign in");
    }
  }
}
