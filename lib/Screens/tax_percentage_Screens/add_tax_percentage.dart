import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Add_View_Tax_Percentage extends StatefulWidget {
  @override
  _Add_View_Tax_PercentageState createState() =>
      _Add_View_Tax_PercentageState();
}

class _Add_View_Tax_PercentageState extends State<Add_View_Tax_Percentage> {
  TextEditingController Controller_Tax_Percentage = TextEditingController();
  bool is_per_tx = false;
  File PNTN_CERTIFICATE = null;
  FocusNode Focus_Node_Tax_Percentage;
  bool is_tax_Percentage = false;
  bool is_already_tax_added = false;
  bool is_edit = false;
  bool is_Loading = true;
  int td_id;
  Future<String> _get_tax_percentage_details() async {
    setState(() {
      is_Loading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(
      K_API_Initial_Address + "users/getTaxPercentageByUserId",
      headers: headers,
      body: json.encode({
        "user_id": user.user_id,
      }),
    );
    var data = json.decode(response.body);
    print("Data = ${data}");
    if (response.statusCode == 200) {
      if (data["tax_detail"] == null) {
        setState(() {
          is_already_tax_added = false;
          is_Loading = false;
        });
      } else {
        setState(() {
          is_Loading = false;
          is_already_tax_added = true;
          Controller_Tax_Percentage.text = data["tax_detail"]["tax_percentage"];
          td_id = data["tax_detail"]["td_id"];
          is_tax_Percentage = true;
        });
      }
    } else {
      MyToast(msg: "Failed to get Details \n Please Try again");
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _get_tax_percentage_details();
    Focus_Node_Tax_Percentage = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tax Percentage"),
          actions: [
            is_already_tax_added
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        is_edit = true;
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(),
            is_already_tax_added
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Container(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Tax Percentage will be deleted permanently.",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.blue),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Center(
                                            child: Text(
                                              "Are you Sure?",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Container(
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _Delete_Tax_Percentage();
                                        },
                                      ),
                                      height: 35,
                                      width: 55,
                                    ),
                                    Container(
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      height: 35,
                                      width: 55,
                                    ),
                                  ],
                                );
                              }));
                    },
                    // onPressed: (){
                    //
                    //   _Delete_Tax_Percentage();
                    // },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: WillPopScope(
          child: !is_Loading
              ? ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    //Tax Percentage CheckBox
                    InkWell(
                      onTap: !is_already_tax_added || is_edit
                          ? () {
                              setState(() {
                                is_tax_Percentage = !is_tax_Percentage;
                              });
                            }
                          : () {
                              MyToast(
                                  msg:
                                      "Please press edit icon to change this field");
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
                              "Tax Percentage",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18),
                            ),
                            Checkbox(
                                value: is_tax_Percentage,
                                activeColor: Colors.blue,
                                checkColor: Colors.blue,
                                onChanged: !is_already_tax_added || is_edit
                                    ? (value) {
                                        setState(() {
                                          is_tax_Percentage =
                                              !is_tax_Percentage;
                                        });
                                      }
                                    : (value) {
                                        return;
                                      }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Tax Percentage
                    is_tax_Percentage
                        ? Container(
                            padding: EdgeInsets.only(left: 20),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.blue),
                                borderRadius: BorderRadius.circular(10)),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                TextFormField(
                                  onTap: !(is_edit || !is_already_tax_added)
                                      ? () {
                                          MyToast(
                                              msg:
                                                  "Please press edit icon to edit this field");
                                        }
                                      : () {},
                                  readOnly: is_edit || !is_already_tax_added
                                      ? false
                                      : true,
                                  controller: Controller_Tax_Percentage,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("^[0-9]{0,2}(\\.[0-9]{0,3})?"))
                                  ],
                                  toolbarOptions: ToolbarOptions(
                                      cut: true, paste: true, selectAll: true),
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      labelText: "Tax (%)",
                                      errorText: is_per_tx
                                          ? "Enter Tax Percentage"
                                          : null,
                                      errorStyle: TextStyle(fontSize: 15),
                                      labelStyle:
                                          TextStyle(color: Colors.blueAccent)),
                                  focusNode: Focus_Node_Tax_Percentage,
                                  onFieldSubmitted: (value) {
                                    Focus_Node_Tax_Percentage.unfocus();
                                    if (Controller_Tax_Percentage
                                        .text.isEmpty) {
                                      setState(() {
                                        is_per_tx = true;
                                      });
                                      Focus_Node_Tax_Percentage.requestFocus();
                                    } else {
                                      setState(() {
                                        is_per_tx = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    //PNTN Certificate
                    is_tax_Percentage && !is_already_tax_added
                        ? Container(
                            padding: EdgeInsets.all(5),
                            // height: 120,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.blue),
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              onTap: () {
                                getImage(1);
                              },
                              child: PNTN_CERTIFICATE == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Text("Upload PNTN Certificate",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20)),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        PNTN_CERTIFICATE,
                                        fit: BoxFit.scaleDown,
                                      )),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    // Next Button
                    is_tax_Percentage && (!is_already_tax_added || is_edit)
                        ? Container(
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
                                    if (Controller_Tax_Percentage
                                        .text.isEmpty) {
                                      MyToast(
                                          msg: "Please Enter Tax Percentage");
                                      Focus_Node_Tax_Percentage.requestFocus();
                                      return;
                                    }

                                    if (PNTN_CERTIFICATE == null &&
                                        !is_already_tax_added) {
                                      MyToast(
                                          msg:
                                              "Please Upload your PNTN Certificate");
                                      return;
                                    }
                                    !is_edit
                                        ? _Add_Tax_Percentage()
                                        : _Edit_Tax_Percentage();
                                  },
                                  child: Center(
                                    child: Text(
                                      !is_edit
                                          ? "Add Tax Percentage"
                                          : "Update Tax Percentage",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
        ));
  }

  Future<bool> getImage(int i) async {
    var img = null;
    try {
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
      print(base64Encode(img.readAsBytesSync()));
    } catch (e) {
      print(e);
      MyToast(msg: "Failed to Pick Image");
      return img;
    }
    if (img != null) {
      if (i == 1) {
        print(img);
        setState(() {
          PNTN_CERTIFICATE = img;
        });
      }
    }
  }

  Future<void> _Add_Tax_Percentage() async {
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
                  backgroundColor: Colors.white,
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
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      final response =
          await http.post(K_API_Initial_Address + "users/addTaxPercentage",
              headers: headers,
              body: json.encode({
                "tax_detail": {
                  "user": user.user_id,
                  "tax_percentage": Controller_Tax_Percentage.text,
                  "pntn_certificate": base64Encode(PNTN_CERTIFICATE.readAsBytesSync()),
                  "pntn_filename":PNTN_CERTIFICATE.path.split('/').last,
                }
              }));
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        await Future.delayed(Duration(seconds: 2));
        MyToast(msg: "Tax Percentage Added Successfully");
        Navigator.pop(context);

        _get_tax_percentage_details();
      } else {
        MyToast(msg: "Failed to Add Tax Percentage");
        Navigator.pop(context);
      }
    } catch (e) {
      print("Exception = $e");
      MyToast(msg: "Action failed \n Please try again");
      Navigator.pop(context);
    }
  }

  Future<void> _Edit_Tax_Percentage() async {
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
                  backgroundColor: Colors.white,
                  strokeWidth: 2,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Updating record...\nPlease wait...",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.none),
                ),
              ],
            )));
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      final response =
          await http.post(K_API_Initial_Address + "users/updateTaxPercentage",
              headers: headers,
              body: json.encode({
                "tax_detail": {
                  "user": user.user_id,
                  "tax_percentage": Controller_Tax_Percentage.text,
                  "td_id": td_id,
                }
              }));
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        await Future.delayed(Duration(seconds: 2));
        MyToast(msg: "Tax Percentage Updated Successfully");
        setState(() {
          is_edit = false;
          PNTN_CERTIFICATE = null;
          Controller_Tax_Percentage.clear();
          is_tax_Percentage = false;
        });
        Navigator.pop(context);
        _get_tax_percentage_details();
      } else {
        MyToast(msg: "Failed to Add Tax Percentage");
        Navigator.pop(context);
      }
    } catch (e) {
      print("Exception = $e");
      MyToast(msg: "Action failed \n Please try again");
      Navigator.pop(context);
    }
  }

  Future<void> _Delete_Tax_Percentage() async {
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
                  "Deleting record...\nPlease wait...",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.none),
                ),
              ],
            )));
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      final response =
          await http.post(K_API_Initial_Address + "users/deleteTaxPercentage",
              headers: headers,
              body: json.encode({
                "td_id": td_id,
              }));
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        await Future.delayed(Duration(seconds: 2));
        MyToast(msg: "Tax Percentage Deleted Successfully");
        setState(() {
          is_edit = false;
          PNTN_CERTIFICATE = null;
          Controller_Tax_Percentage.clear();
          is_tax_Percentage = false;
          is_already_tax_added = false;
        });
        Navigator.pop(context);
        _get_tax_percentage_details();
      } else {
        MyToast(msg: "Failed to Delete Tax Percentage");
        Navigator.pop(context);
      }
    } catch (e) {
      print("Exception = $e");
      MyToast(msg: "Action failed \n Please try again");
      Navigator.pop(context);
    }
  }
}
