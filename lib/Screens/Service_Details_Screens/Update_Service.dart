import 'dart:convert';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/Service_Details_Screens/view_Service_details.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/laundry_category.dart';
import 'package:easy_laundry/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:search_choices/search_choices.dart';

class Update_Service extends StatefulWidget {
  final Laundry_Owner_Service Los;
  final String service_name;
  Update_Service({this.Los,this.service_name});
  @override
  _Update_ServiceState createState() => _Update_ServiceState();
}

class _Update_ServiceState extends State<Update_Service> {


  TextEditingController Controller_service_category = TextEditingController();
  TextEditingController Controller_service_name = TextEditingController();
  TextEditingController Controller_service_Description = TextEditingController();
  TextEditingController Controller_service_Charges = TextEditingController();
  FocusNode Focus_Node_Description;
  FocusNode Focus_Node_Charges;
  bool is_description_error = false;
  bool is_charges_error = false;


  @override void initState() {
    super.initState();
    Controller_service_name.text = widget.service_name.trim();
    Controller_service_category.text = widget.Los.laundry_owner_service_name.trim();
    Controller_service_Charges.text = widget.Los.service_charges.toString().trim();
    Controller_service_Description.text = widget.Los.service_Description.trim();
    Focus_Node_Charges = FocusNode();
    Focus_Node_Description = FocusNode();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Service"),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>View_Service_Details()));
        },
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 20,),
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
                        readOnly: true,
                        onTap: (){
                          MyToast(msg: "This is read only");
                        },
                        controller: Controller_service_category,
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
                            labelText: "Category",
                            errorStyle: TextStyle(fontSize: 15),
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
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
                        readOnly: true,
                        onTap: (){
                          MyToast(msg: "This is read only");
                        },
                        controller: Controller_service_name,
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
                            labelText: "Service",
                            errorStyle: TextStyle(fontSize: 15),
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
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
                        maxLines:5,
                        minLines: 1,
                        controller: Controller_service_Description,
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
                            labelText: "Description",
                            errorText: is_description_error?"*required":null,
                            errorStyle: TextStyle(fontSize: 15),
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                        focusNode: Focus_Node_Description,
                        onFieldSubmitted: (value) {
                          Focus_Node_Description.unfocus();
                          if(value.length==0)
                          {
                            setState(() {
                              is_description_error = true;
                              Focus_Node_Description.requestFocus();
                            });
                          }
                          else
                          {
                            setState(() {
                              is_description_error = false;
                              Focus_Node_Charges.requestFocus();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
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
                        controller: Controller_service_Charges,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("^[0-9]*"))],
                        toolbarOptions:
                        ToolbarOptions(cut: true, paste: true, selectAll: true),
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
                            labelText: "Charges",
                            errorText: is_charges_error?"*required":null,
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                        focusNode: Focus_Node_Charges,
                        onFieldSubmitted: (value) {
                          Focus_Node_Charges.unfocus();
                          if(value.length==0)
                          {
                            setState(() {
                              is_charges_error = true;
                              Focus_Node_Charges.requestFocus();
                            });
                          }
                          else{
                            setState(() {
                              is_charges_error=false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Expanded(child: SizedBox()),
                Container(
                  margin: const EdgeInsets.only(top: 10,left: 20,right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 60,
                      child: RaisedButton(
                        color: Color(0xFF3698CF),
                        onPressed: () {
                          if(Controller_service_Description.text.length==0)
                          {
                            setState(() {
                              is_description_error = true;
                              Focus_Node_Description.requestFocus();
                            });
                            MyToast(msg: "Please Enter Description");
                            return;
                          }
                          if(Controller_service_Charges.text.length==0)
                          {
                            setState(() {
                              is_charges_error = true;
                              Focus_Node_Charges.requestFocus();
                            });
                            MyToast(msg: "Please Enter Charges");
                            return;
                          }
                          if(Controller_service_Description.text==widget.Los.service_Description.trim()&&Controller_service_Charges.text==widget.Los.service_charges.toString().trim())
                            {
                              MyToast(msg: "Please change your data you want to update");
                              return;
                            }else{
                            _upload_data();
                          }
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
              ],
            ),
          ],
        ),
      ),
    );
  }
  _upload_data()async{
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
                  "Updating Data...\nPlease wait...",
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
          K_API_Initial_Address + "services/updateService",
          headers: headers,
          body:json.encode(
              {
                "service":{
                  "los_id": widget.Los.los_id,
                  "service": widget.Los.Laundry_service_id,
                  "laundry_owner": user.user_id,
                  "description": Controller_service_Description.text,
                  "charges": int.parse(Controller_service_Charges.text),
                }
              }
          ));
      if(response.statusCode==200)
      {
        MyToast(msg: "Laundry Service Updated Successfully");
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => View_Service_Details()));
      }
      else
      {
          MyToast(msg: "Failed to Update Service");
          Navigator.pop(context);
      }
    }catch(e)
    {
      print("Exception = $e");
      MyToast(msg: "Error while adding Service \n Please try again");
      Navigator.pop(context);
    }
  }
}
