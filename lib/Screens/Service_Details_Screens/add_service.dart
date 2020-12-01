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

class Add_Service extends StatefulWidget {
  @override
  _Add_ServiceState createState() => _Add_ServiceState();
}

class _Add_ServiceState extends State<Add_Service> {


  TextEditingController Controller_service_Description = TextEditingController();
  TextEditingController Controller_service_Charges = TextEditingController();
  FocusNode Focus_Node_Description;
  FocusNode Focus_Node_Charges;
  bool is_description_error = false;
  bool is_charges_error = false;
  int Selected_Category;
  int Selected_Service;
  List<Category>category_list = [];
  List<Laundry_Service>Laundry_Services = [];
  bool is_Loading=true;
  int cat_id=-1;
  int ser_id = -1;
  Future<void>_get_Categories()async{
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.get(
      K_API_Initial_Address+"services/findAllCategories",
      headers: headers,
    );
    var data = json.decode(response.body);
    List<dynamic>a =  data["service_categories"];
    if(response.statusCode==200)
    {
        for(int i = 0; i<a.length;i++)
        {
          category_list.add(Category(category: a[i]["category"],category_id: a[i]["category_id"]));
        }
      setState(() {
        Selected_Category = category_list[0].category_id;
        cat_id = category_list[0].category_id;
        _get_services(category_list[0].category_id);
        // is_Loading = false;
      });
    }
  }
  Future<void>_get_services(int id)async{
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    setState(() {
      is_Loading = true;
    });
    var response = await http.post(
      K_API_Initial_Address+"services/findByCategory",
      headers: headers,
      body: json.encode({
        "category_id": id,
    }),
    );
    var data = json.decode(response.body);
    print(data.toString());
    Laundry_Services.clear();
    List<dynamic>a =  data["services"];
    // MyToast(msg: "${a.length.toString()}");
    if(response.statusCode==200)
     {
       if(a.length!=0)
        for(int i = 0; i<a.length;i++)
        {
          Laundry_Services.add(
              Laundry_Service(
               category_id: a[i]["service_category"]["category_id"],
                Laundry_service_id:a[i]["service_id"] ,
                Laundry_service_name:a[i]["service_name"]
              ));
        }
      setState(() {
        if(a.length!=0)
          {
            Selected_Service = Laundry_Services[0].Laundry_service_id;
            ser_id = Selected_Service;
          }

        is_Loading = false;
      });
    }
  }

  @override void initState() {
    super.initState();
    _get_Categories();
    Focus_Node_Charges = FocusNode();
    Focus_Node_Description = FocusNode();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Service"),
      ),
      body: WillPopScope(
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20,left: 25),
                  child: Text("Category:",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      border:Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: SearchChoices.single(
                      items: category_list.map((dropdownitem) {
                        return DropdownMenuItem(
                          child: Text("${dropdownitem.category}"),
                          value: dropdownitem.category_id,
                        );
                      }).toList(),
                      displayClearIcon: false,
                      underline: SizedBox(),
                      iconEnabledColor: Colors.blue,
                      iconDisabledColor: Colors.blue,
                      value: Selected_Category,
                      hint: "Select Category",
                      searchHint: "Select Category",
                      style: TextStyle(fontSize: 15,color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          cat_id = value;
                          int index = category_list.indexWhere((element) => element.category_id==value);
                          this.Selected_Category = category_list[index].category_id;
                          _get_services(cat_id);
                        });
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Text("Service:",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 5,),
                Laundry_Services.length!=0
                    ? Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      border:Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: SearchChoices.single(
                      items: Laundry_Services.map((dropdownitem) {
                        return DropdownMenuItem(
                          child: Text("${dropdownitem.Laundry_service_name}"),
                          value: dropdownitem.Laundry_service_id,
                        );
                      }).toList(),
                      displayClearIcon: false,
                      underline: SizedBox(),
                      iconEnabledColor: Colors.blue,
                      iconDisabledColor: Colors.blue,
                      value: Selected_Service,
                      hint: "Select Service",
                      searchHint: "Select Service",
                      style: TextStyle(fontSize: 15,color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          ser_id = value;
                          int index = Laundry_Services.indexWhere((element) => element.Laundry_service_id==value);
                          this.Selected_Service = Laundry_Services[index].Laundry_service_id;
                        });
                      },
                      dialogBox: true,
                      isExpanded: true,
                    ),
                  ),
                )
                    :Container(
                  height: 72,
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      border:Border.all(width: 2, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("No Servie of Selected Category",),
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
                          if(Laundry_Services.length==0||Selected_Service==-1)
                            {
                              MyToast(msg: "Please Select a Service");
                              return;
                            }
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
                          _upload_data();
                        },
                        child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            is_Loading?
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  // margin: EdgeInsets.all(10),
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ):SizedBox()
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
          K_API_Initial_Address + "services/addService",
          headers: headers,
          body:json.encode(
              {
                    "service":{
                      "service": ser_id,
                      "laundry_owner": user.user_id,
                      "description": Controller_service_Description.text,
                      "charges": int.parse(Controller_service_Charges.text),
                    }
              }
          ));
      if(response.statusCode==200)
      {
            MyToast(msg: "Laundry Service Added Successfully");
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (BuildContext) => View_Service_Details()));
      }
      else
      {
        if(response.body=="The Service for this Laundry owner already Exist")
          {
            MyToast(msg: "The Service for this Laundry owner already Exist");
            Navigator.pop(context);
          }
        else {
          MyToast(msg: "Failed to Add Service");
          Navigator.pop(context);
        }
      }
    }catch(e)
    {
      print("Exception = $e");
      MyToast(msg: "Error while adding Service \n Please try again");
      Navigator.pop(context);
    }
  }
}
