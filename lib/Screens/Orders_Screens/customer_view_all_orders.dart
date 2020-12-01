import 'dart:convert';
import 'package:easy_laundry/models/order_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class Customer_View_All_Orders extends StatefulWidget {
  final int cust_id;
  final Order_Status obj_status;
  Customer_View_All_Orders({this.cust_id,this.obj_status});
  @override
  _Customer_View_All_OrdersState createState() => _Customer_View_All_OrdersState();
}

class _Customer_View_All_OrdersState extends State<Customer_View_All_Orders> {
  bool is_Loading= true;
  List<Order>orders_list = [];
  TextEditingController Controller_Review = TextEditingController();
  bool is_Review = false;
  double _rating = 3;
  FocusNode Focus_Node_Review;
  TwilioFlutter twilioFlutter;

  _get_All_orders()async{
    setState(() {
      is_Loading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    print("Customer id = ${widget.cust_id}");
    var response = await http.post(
        K_API_Initial_Address+"orders/getOrdersByStatusAndCustomerId",
        headers: headers,
        body: json.encode({
          "customer_id":widget.cust_id,
          "order_status":widget.obj_status.order_status_id,
        })
    );
    orders_list.clear();
    var data = json.decode(response.body);
    // print("data  = ${data["msg"]}");
    if(data["msg"]=="No Order Exist for this Customer")
    {
      setState(() {
        is_Loading= false;
      });
      return;
    }
    if(response.statusCode==200)
    {
      for(int i = 0;i<data['orders'].length;i++)
      {
        orders_list.add(
          Order(
            order_laundry_name: "${data['orders'][i]["los"]["laundry_owner"]["address"]["laundry_name"]}",
            order_price: data["orders"][i]["total_price"],
            order_qty: data["orders"][i]["quantity"],
            order_service_name:data["orders"][i]["los"]["service"]["service_name"],
            Order_status: data["orders"][i]["order_status"]["status"],
            order_status_id: data["orders"][i]["order_status"]["order_status_id"],
            Comment: data['orders'][i]['comment'],
            order_id: data["orders"][i]["order_id"],
            Laundry_owner_id: data['orders'][i]["los"]["laundry_owner"]["user_id"],
            Laundry_Owner_Mobile_no:data['orders'][i]["los"]["laundry_owner"]["mobile_no"],
          )
        );
      }
      setState(() {
        is_Loading=false;
      });
    }
    else{
      MyToast(msg: "Failed to get Orders data.");
      Navigator.pop(context);
    }
    return;
  }

  @override
  void initState() {
    Focus_Node_Review = FocusNode();
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
    _get_All_orders();
    super.initState();
  }
  int selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.obj_status.status} Orders"),
      ),
      body: WillPopScope(
        child:
        !is_Loading?
        orders_list.length==0
            ?Center(
              child: Text(
                "No Order with this Status",
                style: TextStyle(color: Colors.blue,fontSize: 20),
              ),
            ):Container(
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: ListView.builder(
              key : Key('builder ${selected.toString()}'),
              itemCount: orders_list.length,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Oder Service Name
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
                                      "Service:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.blue
                                      ),
                                    ),
                                    Text(
                                      "${orders_list[index].order_service_name}",
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
                                        "Status:",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      Text(
                                        orders_list[index].Order_status,
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Laundry Name: ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            orders_list[index].order_laundry_name,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Quantity: ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            orders_list[index].order_qty.toString(),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Total Price: ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            orders_list[index].order_price.toString(),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      // Comment
                                      orders_list[index].Comment!=null && orders_list[index].Comment!=""?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                          "Comment: ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              orders_list[index].Comment,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ):SizedBox(),
                                    ],
                                  ),
                                ),
                                // Divider(),
                              ],
                            ),
                          ),
                        ),
                        widget.obj_status.order_status_id==6?
                        IconButton(
                          tooltip: "Rate and Review",
                            icon: Icon(Icons.rate_review,size:20,color: Colors.blue,),
                            onPressed: (){
                            setState(() {
                              _rating = 3;
                              Controller_Review.clear();
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
                                          "Rate & Review",
                                          style: TextStyle(
                                              color: Colors.blue
                                          ),
                                        ),
                                      ],
                                    ),
                                    content:  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RatingBar(
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          direction: Axis.horizontal,
                                          initialRating: _rating,
                                          maxRating: 5,
                                          itemSize: 35,
                                          glow: false,
                                          onRatingUpdate: (value){
                                            setState((){
                                              _rating = value;
                                            });
                                            print("Rating = $value");
                                          },
                                          minRating: 1,
                                        ),
                                        Text(
                                          "Rating: $_rating",
                                          style: TextStyle(
                                              color: Colors.blue
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        //Review
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
                                                controller: Controller_Review,
                                                toolbarOptions: ToolbarOptions(
                                                    cut: true, paste: true, selectAll: true),
                                                textInputAction: TextInputAction.next,
                                                maxLines: 5,
                                                minLines: 1,
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
                                                    labelText: "Review",
                                                    errorStyle: TextStyle(fontSize: 15),
                                                    labelStyle:
                                                    TextStyle(color: Colors.blueAccent)),
                                                focusNode: Focus_Node_Review,
                                                onFieldSubmitted: (value) {
                                                  Focus_Node_Review.unfocus();
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
                                                _Rate_Laundry_Owner_Service(orders_list[index].Laundry_owner_id,orders_list[index], Controller_Review.text.trim());
                                              },
                                              child: Center(
                                                child: Text(
                                                  "Rate",
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
                              );
                            },
                        ):SizedBox(),
                        SizedBox(width: 20,),
                      ],
                    ),
                    Divider(height: 3,color: Colors.black45,),
                  ],
                );
              }),
            )
            : Center(child: CircularProgressIndicator(strokeWidth: 3,),),
      ),
    );
  }
  _Rate_Laundry_Owner_Service(int laundry_owner_id,Order order,String review,)async{
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
                    Expanded(
                      child: Text(
                        "Please wait while rating is done...",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            decoration: TextDecoration.none),
                      ),
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
          K_API_Initial_Address + "orders/addRatingAndReviews",
          headers: headers,
          body: json.encode({
            "rating_review" : {
              "rating": _rating,
              "reviews": review,
              "laundry_owner": laundry_owner_id,
              "order": order.order_id
            }
          }));
      print("Body = ${response.body}");
      var data = json.decode(response.body);
      if (data["msg"]=="Rating Added Successfully") {
        MyToast(msg: "Rating done Successfully");
        _get_All_orders();
        twilioFlutter.sendSMS(
            toNumber: "${order.Laundry_Owner_Mobile_no}".trim(),
            messageBody: "${order.Customer_name} left a $_rating start review."
        );
      } else
      {
        print("Response = ${response .body}");
        MyToast(msg: "Failed to Update Order Status");
      }
    } catch (e) {
      print("Exception is this = $e");
      // MyToast(msg:"Exception is this = $e");
      MyToast(msg: "Error while Updaing Order Status\n Please try again");
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
