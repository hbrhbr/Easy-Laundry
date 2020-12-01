import 'dart:convert';
import 'package:easy_laundry/Screens/Home_Screen.dart';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/Service_Details_Screens/Update_Service.dart';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/Service_Details_Screens/add_service.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/service_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';

class View_Service_Details extends StatefulWidget {
  final int user_id;
  int is_delivery;
  View_Service_Details({this.user_id,this.is_delivery});
  @override
  _View_Service_DetailsState createState() => _View_Service_DetailsState();
}

class _View_Service_DetailsState extends State<View_Service_Details> {
  Laundry_Owner_Service service= Laundry_Owner_Service();
  TextEditingController Controller_Quantity = TextEditingController();
  bool is_qty = false;
  FocusNode Focus_Node_Quantity;
  TextEditingController Controller_Pickup_Address = TextEditingController();
  bool is_Pickup_Address = false;
  FocusNode Focus_Node_Pickup_Address;
  int selected;
  bool is_loading= true;
  TwilioFlutter twilioFlutter;
  String Laundry_owner_mobile_No;

  @override void initState() {
    _get_Services();
    Focus_Node_Quantity = FocusNode();
    Focus_Node_Pickup_Address = FocusNode();
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    super.initState();
  }
  // ok. US me jitny record aarhy un ko separate sparate dikhao matlab line lga k separate kr do
  //   hr record k neechy aur  sb se Ooper aik main Title do "Laundry Services" k naam se.
  // Aur hr record ki field ka bhi Title do jaisy me ne ooper wali Picture me "Laundry Name"
  // k naam ka title diya hai
  //  "Service Category" "Service Name" "Description" yeh title de do

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Details"),
        actions: [
          user.role==2?IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Add_Service()));
              }
              ):SizedBox(),
        ],
      ),
      body: WillPopScope(
        onWillPop: ()async{
          return user.role==2?
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Home_Screen()))
          :true;
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: !is_loading
            ?Los_list.length==0
              ?Center(
            child: Text(
                "No Service Exist for this Laundry Owner",
              style: TextStyle(color: Colors.blue,),
            ),
          )
               :ListView.builder(
              key : Key('builder ${selected.toString()}'),
              itemCount: Los_list.length,
              itemBuilder: (context,index){
                String service_name = "";
                int idx = LS_list.indexWhere((element) => element.Laundry_service_id==Los_list[index].Laundry_service_id);
                service_name = LS_list[idx].Laundry_service_name;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Laundry Text
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: Key(index.toString()),
                              initiallyExpanded: index == selected,
                              onExpansionChanged: ((newState) {
                                if (newState)
                                  setState(() {
                                    selected = index;
                                  });
                                else
                                  setState(() {
                                    selected = -1;
                                  });
                              }),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 10,top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Category:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.blue
                                      ),
                                    ),
                                    Text(
                                      "${Los_list[index].laundry_owner_service_name}",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              title:Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width: 2,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service:",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue
                                        ),
                                      ),
                                      Text(
                                        "${service_name}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Description:",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                                Los_list[index].service_Description,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                            "Rs."+Los_list[index].service_charges.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider(),
                              ],
                            ),
                          ),
                        ),
                        //Edit Service
                        user.role==2?
                        Container(
                          width: 30,
                          child: IconButton(
                            tooltip: "Edit",
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Update_Service(Los: Los_list[index],service_name: service_name,)));
                            },
                            icon: Icon(Icons.edit,color:Colors.blue),
                          ),
                        ):SizedBox(),
                        SizedBox(width: 5,),
                        //Delete Service
                        user.role==2?
                        Container(
                          width: 30,
                          child: IconButton(
                            tooltip: "Delete",
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Container(
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "${Los_list[index].laundry_owner_service_name} service of $service_name will be deleted permanently.",
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: 15, color: Colors.blue),
                                            ),
                                            SizedBox(height: 10,),
                                            Container(
                                              height:40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(20))),
                                              child: Center(
                                                  child: Text(
                                                      "Are you Sure?",
                                                    style: TextStyle(
                                                      fontSize: 25
                                                    ),
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
                                              _Delete(Los_list[index].los_id);
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
                                  })
                              );
                            },
                            icon: Icon(Icons.delete,color:Colors.blue),
                          ),
                        )
                            :SizedBox(),
                        user.role==3&&widget.is_delivery==1?
                        Container(
                          width: 30,
                          child: IconButton(
                            tooltip: "Order",
                            onPressed: (){
                              Controller_Quantity.text = "";
                              Controller_Pickup_Address.text = "";
                              setState(() {
                                is_qty = false;
                                is_Pickup_Address = false;
                              });
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_)=>StatefulBuilder(
                                  builder:(BuildContext context, StateSetter setState) =>  AlertDialog(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "$service_name'\s Order",
                                          style: TextStyle(
                                            color: Colors.blue
                                          ),
                                        ),
                                      ],
                                    ),
                                    content:  SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 20),
                                            decoration: BoxDecoration(
                                                border:
                                                Border.all(width: 2, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                TextFormField(
                                                  controller: Controller_Quantity,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(
                                                        RegExp("^[0-9]*"))],
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
                                                      labelText: "Quantity",
                                                      errorText: is_qty
                                                          ? "Enter valid Quantity"
                                                          : null,
                                                      errorStyle: TextStyle(fontSize: 15),
                                                      labelStyle:
                                                      TextStyle(color: Colors.blueAccent)),
                                                  focusNode: Focus_Node_Quantity,
                                                  onFieldSubmitted: (value) {
                                                    Focus_Node_Quantity.unfocus();
                                                    if (Controller_Quantity
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        is_qty = true;
                                                      });
                                                      Focus_Node_Quantity.requestFocus();
                                                    } else {
                                                      setState(() {
                                                        is_qty = false;
                                                        Focus_Node_Pickup_Address.requestFocus();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            padding: EdgeInsets.only(left: 20),
                                            decoration: BoxDecoration(
                                                border:
                                                Border.all(width: 2, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                TextFormField(
                                                  controller: Controller_Pickup_Address,
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
                                                      labelText: "PickUp/Delivery Address",
                                                      errorText: is_Pickup_Address
                                                          ? "Enter PickUp/Delivery Address"
                                                          : null,
                                                      errorStyle: TextStyle(fontSize: 15),
                                                      labelStyle:
                                                      TextStyle(color: Colors.blueAccent)),
                                                  focusNode: Focus_Node_Pickup_Address,
                                                  onFieldSubmitted: (value) {
                                                    Focus_Node_Pickup_Address.unfocus();
                                                    if (Controller_Pickup_Address
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        is_Pickup_Address = true;
                                                      });
                                                      Focus_Node_Pickup_Address.requestFocus();
                                                    } else {
                                                      setState(() {
                                                        is_Pickup_Address = false;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 60),
                                              child: RaisedButton(
                                                color: Colors.blue,
                                                onPressed: (){
                                                  if(Controller_Quantity.text.isEmpty)
                                                    {
                                                      MyToast(msg: "Please Enter Quantity");
                                                      setState(() {
                                                        is_qty = true;
                                                        Focus_Node_Quantity.requestFocus();
                                                      });
                                                      return;
                                                    }
                                                  else setState((){
                                                    is_qty = false;
                                                  });
                                                  if(Controller_Pickup_Address.text.isEmpty)
                                                    {
                                                      MyToast(msg: "Please Enter PickUp/Delivery Address");
                                                      setState(() {
                                                        is_Pickup_Address = true;
                                                        Focus_Node_Pickup_Address.requestFocus();
                                                      });
                                                      return;
                                                    }
                                                  else setState((){
                                                    is_Pickup_Address = false;
                                                  });
                                                  int price = int.parse(Controller_Quantity.text);
                                                  int total_price = price*Los_list[index].service_charges;
                                                  _Place_Order(Los_list[index].los_id, user.user_id, price,total_price, Controller_Pickup_Address.text,service_name);
                                                },
                                                child: Center(
                                                  child: Text(
                                                      "Place Order",
                                                    style: TextStyle(
                                                      color: Colors.white
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
                                ),
                              );
                            },
                            icon: Icon(Icons.shopping_cart,color:Colors.blue),
                          ),
                        ):SizedBox(),
                        SizedBox(width: 10,),
                        user.role==3?
                        Container(
                          width: 30,
                          child: IconButton(
                            tooltip: "Post Appointment",
                            onPressed: (){
                              Controller_Quantity.text = "";
                              setState(() {
                                is_qty = false;
                              });
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_)=>StatefulBuilder(
                                  builder:(BuildContext context, StateSetter setState) =>  AlertDialog(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "$service_name'\s Appointment",
                                            style: TextStyle(
                                              color: Colors.blue
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content:  SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 20),
                                            decoration: BoxDecoration(
                                                border:
                                                Border.all(width: 2, color: Colors.blue),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              children: <Widget>[
                                                TextFormField(
                                                  controller: Controller_Quantity,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(
                                                        RegExp("^[0-9]*"))],
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
                                                      labelText: "Quantity",
                                                      errorText: is_qty
                                                          ? "Enter valid Quantity"
                                                          : null,
                                                      errorStyle: TextStyle(fontSize: 15),
                                                      labelStyle:
                                                      TextStyle(color: Colors.blueAccent)),
                                                  focusNode: Focus_Node_Quantity,
                                                  onFieldSubmitted: (value) {
                                                    Focus_Node_Quantity.unfocus();
                                                    if (Controller_Quantity
                                                        .text.isEmpty) {
                                                      setState(() {
                                                        is_qty = true;
                                                      });
                                                      Focus_Node_Quantity.requestFocus();
                                                    } else {
                                                      setState(() {
                                                        is_qty = false;
                                                        Focus_Node_Pickup_Address.requestFocus();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              child: RaisedButton(
                                                color: Colors.blue,
                                                onPressed: (){
                                                  if(Controller_Quantity.text.isEmpty)
                                                    {
                                                      MyToast(msg: "Please Enter Quantity");
                                                      setState(() {
                                                        is_qty = true;
                                                        Focus_Node_Quantity.requestFocus();
                                                      });
                                                      return;
                                                    }
                                                  else setState((){
                                                    is_qty = false;
                                                  });
                                                  int quantity = int.parse(Controller_Quantity.text);
                                                  int total_price = quantity*Los_list[index].service_charges;
                                                  _Post_Appointment(Los_list[index].los_id, user.user_id, quantity,total_price, service_name);
                                                },
                                                child: Center(
                                                  child: Text(
                                                      "Post Appointment Request",
                                                    style: TextStyle(
                                                      color: Colors.white
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
                                ),
                              );
                            },
                            icon: Icon(Icons.add_to_queue,color:Colors.blue),
                          ),
                        ):SizedBox(),
                        SizedBox(width: 10,),
                      ],
                    ),
                    Divider(height: 3,color: Colors.black45,),
                  ],
                );
              }
          )
            :Center(child: CircularProgressIndicator(strokeWidth: 3,),),
        ),
        ),
    );
  }

  //Post Appointment
  _Post_Appointment(int los_id,int customer_id,int qty,int total_price,String service_name)async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) =>
            AlertDialog(
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
                    )
                  ],
                )));
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      };
      final response = await http.post(
          K_API_Initial_Address + "appointments/placeAppointment",
          headers: headers,
          body: json.encode({
            "appointment": {
              "los": los_id,
              "customer": customer_id,
              "laundry_owner_id":widget.user_id,
              "quantity": qty,
              "total_price": total_price,
            }
          }));
      print("Body = ${response.body}");
      if (response.statusCode==200) {
        MyToast(msg: "Appointment Request sent Successfully");
        twilioFlutter.sendSMS(
            toNumber: "${Laundry_owner_mobile_No}".trim(),
            messageBody: '${user.first_name.trim()}${user.last_name.trim()}'.trim()+""
                " just requested for appointment of $service_name\'s Service \n"
                "Quantity = $qty \n"
                "Total Price = $total_price Rs.");
      } else
      {
        print("Response = ${response .body}");
        MyToast(msg: "Failed to request appointment");
      }
    } catch (e) {
      print("Exception is this = $e");
      // MyToast(msg:"Exception is this = $e");
      MyToast(msg: "Error while requesting appointment\n Please try again");
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _Place_Order(int los_id,int customer_id,int qty,int total_price,String Address,String service_name)async{
    // print("Order = ${widget.user_id}");
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) =>
            AlertDialog(
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
                      "Placing Order...\nPlease wait...",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
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
      final response = await http.post(
          K_API_Initial_Address + "orders/placeOrder",
          headers: headers,
          body: json.encode({
            "order": {
              "los": los_id,
              "customer": customer_id,
              "quantity": qty,
              "total_price": total_price,
              "pickup_address": Address,
              "laundry_owner_id":widget.user_id,
            }
          }));
      print("Body = ${response.body}");
      if (response.statusCode==200) {
        MyToast(msg: "Order Placed Successfully");
        twilioFlutter.sendSMS(
            toNumber: "${Laundry_owner_mobile_No}".trim(),
            messageBody: '${user.first_name.trim()}${user.last_name.trim()}'.trim()+""
                " just placed an order for $service_name\'s Service \n"
                "Quantity = $qty \n"
                "Total Price = $total_price Rs. \n"
                "PickUp/Deliver Address = $Address");
      } else
      {
        print("Response = ${response .body}");
        MyToast(msg: "Failed to Place Order");
      }
    } catch (e) {
      print("Exception is this = $e");
      // MyToast(msg:"Exception is this = $e");
      MyToast(msg: "Error while Placing Order\n Please try again");
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }
  _Delete(int los_id)async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) =>
            AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.black87,
                      strokeWidth: 6,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Deleting Service...\nPlease wait...",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
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
      final response = await http.post(
          K_API_Initial_Address + "services/deleteService",
          headers: headers,
          body: json.encode({
            "los_id": los_id,
          }));
      print("Body = ${response.body}");
      if (response.statusCode==200) {
          MyToast(msg: "Deleted Successfully");
          setState(() {
            is_loading=true;
          });
          _get_Services();
      } else
      {
        print("Response = ${response .body}");
        MyToast(msg: "Failed to Delete");
      }
    } catch (e) {
      print("Exception is this = $e");
      // MyToast(msg:"Exception is this = $e");
      MyToast(msg: "Error while Deleting\n Please try again");
    }
    Navigator.pop(context);
  }

  List<Laundry_Owner_Service> Los_list = [];
  List<Laundry_Service>LS_list = [];
  Future<void> _get_Services()async{
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(
      K_API_Initial_Address+"services/findByLaundryOwner",
      headers: headers,
      body: json.encode({
        "laundry_owner":widget.user_id,
      })
    );
    Los_list.clear();
    LS_list.clear();
    if(response.body=="No Service Exist for this Laundry Owner")
      {
        setState(() {
          is_loading= false;
        });
        return;
      }
    var data = json.decode(response.body);
    print("Service Response = $data");
    if(response.statusCode==200)
      {
        Laundry_owner_mobile_No = data['services'][0]["laundry_owner"]["mobile_no"];
        print("Mobile No = $Laundry_owner_mobile_No");
        for(int i = 0;i<data['services'].length;i++)
        {

          Los_list.add(Laundry_Owner_Service(
            service_Description: data['services'][i]["description"],
            service_charges: data['services'][i]["charges"],
            los_id: data['services'][i]["los_id"],
            laundry_owner_service_name: data['services'][i]["service"]['service_category']["category"],
            Laundry_service_id: data['services'][i]["service"]["service_id"],
          ));
          LS_list.add(Laundry_Service(
            Laundry_service_id: data['services'][i]["service"]["service_id"],
            Laundry_service_name:data['services'][i]["service"]["service_name"],
            category_id: data['services'][i]["service"]["service_category"]["category_id"],
          ));
        }
        setState(() {
          is_loading=false;
        });
      }
    else{
     MyToast(msg: "Failed to get data.");
     Navigator.pop(context);
    }
    return;
  }
}