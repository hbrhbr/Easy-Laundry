import 'dart:convert';

import 'package:easy_laundry/Screens/Home_Screen.dart';
import 'package:easy_laundry/Screens/forgot_password.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Change_Password extends StatefulWidget {
  @override
  _Change_PasswordState createState() => _Change_PasswordState();
}

class _Change_PasswordState extends State<Change_Password> {
  TextEditingController Controller_Password = TextEditingController();
  TextEditingController Controller_Confrim_Password = TextEditingController();
  bool is_password = false;
  bool is_hide_password = true;
  bool is_confirm_password = false;
  FocusNode Focus_Node_password;
  FocusNode Focus_Node_confirm_password;
  user_model user_provider;


  @override
  void initState() {
    Focus_Node_confirm_password = FocusNode();
    Focus_Node_password = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user_provider = Provider.of<user_model>(context);
    return Scaffold(
      body: WillPopScope(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Column(
              children: [
                SizedBox(height: 100,),
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
              ],
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
                      if (Controller_Password.text.isEmpty) {
                        MyToast(msg: "Please Enter Password");
                        return;
                      }
                      if (Controller_Confrim_Password.text.isEmpty) {
                        MyToast(msg: "Please Confirm password");
                        return;
                      }
                      _Reset_Password();
                    },
                    child: Center(
                      child: Text(
                        "Change Password",
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
      if(response.statusCode==200)
      {
        MyToast(msg: "Password Updated Successfully");
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => Home_Screen()));
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
