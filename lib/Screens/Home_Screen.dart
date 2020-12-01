import 'dart:convert';
import 'package:easy_laundry/Screens/login_screen.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/components/drawer.dart';
import 'package:easy_laundry/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}


class _Home_ScreenState extends State<Home_Screen> {

  Future<bool> _onwillpop() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("Do you want to Logout???"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Login_Page()));
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }


  _get_dashboard_details()async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };

    try{
      var response =
      user.role==3?
      await http.post(
        K_API_Initial_Address+"orders/customerOrderStatistics",
        // K_API_Initial_Address+"user/laundryOrderStatistics",
        headers: headers,
        body: json.encode({
          "customer_id" : user.user_id,
        }),
      )
          :await http.post(
        K_API_Initial_Address+"orders/laundryOrderStatistics",
        // K_API_Initial_Address+"user/laundryOrderStatistics",
        headers: headers,
        body: json.encode({
          "laundry_owner_id" : user.user_id,
        }),
      );
      var data = json.decode(response.body);
      print("Data = $data");
      order_pickup_request = data['request_for_pickup'];
      order_request_accepted = data["request_accepted"];
      order_picked= data["picked"];
      order_in_progress= data["in_progress"];
      order_ready_for_delivery= data["ready_for_delivery"];
      order_delivered= data["delivered"];
      order_rejected= data["rejected"];
      appointment_new= data["new_appointment"];
      appointment_accepted= data["appointment_accepted"];
      appointment_in_progress= data["appointment_in_progress"];
      appointment_completed= data["appointment_completed"];
      appointment_rejected= data["appointment_rejected"];
      setState(() {
        is_Loading = false;
      });
    }catch(e){
      print("Exception = $e");
      MyToast(msg: "Connection Error.");
      setState(() {
        is_Loading = false;
      });
    }
  }

  @override void initState() {
    _get_dashboard_details();
    super.initState();
  }

  bool is_Loading = true;
  int order_pickup_request=0;
  int order_request_accepted=0;
  int order_picked=0;
  int order_in_progress=0;
  int order_ready_for_delivery=0;
  int order_delivered=0;
  int order_rejected=0;
  int appointment_new=0;
  int appointment_accepted=0;
  int appointment_in_progress=0;
  int appointment_completed=0;
  int appointment_rejected=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: !is_Loading?myDrawer():SizedBox(),
      appBar: AppBar(
        title: Text("Easy Laundry"),
      ),
      body: WillPopScope(
        onWillPop: _onwillpop,
        child: Center(
          child: is_Loading
              ?CircularProgressIndicator()
              :Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black,width: 1),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                            ),
                            height: 35,
                            child: Center(
                                child: Text(
                                    "Order",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight:FontWeight.bold
                                  ),
                                ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Colors.black),
                                ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Pickup Requests: $order_pickup_request",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Accepted Requests: $order_request_accepted",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Picked: $order_picked",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "In Progress: $order_in_progress",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Ready for Delivery: $order_ready_for_delivery",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Delivered: $order_delivered",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Rejected: $order_rejected",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(color: Colors.black,width: 1),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                            ),
                            height: 35,
                            child: Center(
                              child: Text(
                                "Appointment",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight:FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1,color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "New: $appointment_new",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Accepted: $appointment_accepted",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "In Progress: $appointment_in_progress",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Completed: $appointment_completed",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10),),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Rejected: $appointment_rejected",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
