import 'dart:convert';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:easy_laundry/constants.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class laundry_View_All_customers_Orders extends StatefulWidget {
  final int laundry_owner_id;
  final Order_Status obj_status;
  laundry_View_All_customers_Orders({this.laundry_owner_id,this.obj_status});
  @override
  _laundry_View_All_customers_OrdersState createState() => _laundry_View_All_customers_OrdersState();
}

class _laundry_View_All_customers_OrdersState extends State<laundry_View_All_customers_Orders> {
  bool is_Loading= true;
  List<Order>orders_list = [];
  int selected_status_id;
  bool is_reject= false;
  TextEditingController Controller_Comment = TextEditingController();
  bool is_Comment = false;
  FocusNode Focus_Node_Comment;
  TwilioFlutter twilioFlutter;

  _get_All_orders()async{
    Focus_Node_Comment = FocusNode();
    orders_list.clear();
    setState(() {
      is_Loading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };

    try{
      var response = await http.post(
          K_API_Initial_Address+"orders/getOrdersByStatusAndaundryId",
          headers: headers,
          body: json.encode({
            "laundry_owner_id":widget.laundry_owner_id,
            "order_status":widget.obj_status.order_status_id,
          })
      );
      var data = json.decode(response.body);
      // print("data  = ${data["orders"].length}");
      print("data  = ${data}");
      if(data["msg"]=="No New Order Exist for this Laundry"||data["msg"]=="No Order Exist for this Laundry")
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
          print("Order No ${i+1} = ${data['orders'][i]["order_status"]}");
          orders_list.add(
              Order(
                order_laundry_name: "${data['orders'][i]["los"]["laundry_owner"]["address"]["laundry_name"]}",
                order_price: data["orders"][i]["total_price"],
                order_qty: data["orders"][i]["quantity"],
                order_service_name:data["orders"][i]["los"]["service"]["service_name"],
                Order_status: data["orders"][i]["order_status"]["status"],
                order_status_id: data["orders"][i]["order_status"]["order_status_id"],
                order_id: data["orders"][i]["order_id"],
                Customer_name: "${data["orders"][i]['customer']['first_name']} ${data["orders"][i]['customer']['last_name']}",
                Category: data['orders'][i]["los"]["service"]["service_category"]["category"],
                pickup_address : data['orders'][i]["pickup_address"],
                Customer_mobile_no: data["orders"][i]['customer']["mobile_no"],
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
    }catch(e)
    {
      print("Exception = $e");
      MyToast(msg: "Error while getting orders \n Please try Again");
      Navigator.pop(context);
    }
    return;
  }

  @override
  void initState() {
    _get_All_orders();
    twilioFlutter = TwilioFlutter(
        accountSid: 'ACf12b1cbd1931709282e749909bb99afd',
        authToken: '877ae996f010fda5876821e0a6a25907',
        twilioNumber: '+19714071490');
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      "Customer:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.blue
                                      ),
                                    ),
                                    Text(
                                      "${orders_list[index].Customer_name}",
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
                                        "Category:",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      Text(
                                        orders_list[index].Category,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  widget.obj_status.order_status_id==6||widget.obj_status.order_status_id==7?
                                  SizedBox() :IconButton(
                                      tooltip: "Change Status",
                                      enableFeedback: false,
                                      icon: Icon(Icons.edit,size:20,color: Colors.blue,),
                                      onPressed: (){
                                        List<Order_Status>local_status_list = [];
                                        print("Status = ${orders_list[index].order_status_id}");
                                        setState(() {
                                          selected_status_id = orders_list[index].order_status_id;

                                          status_list.forEach((status) {
                                            if(status.order_status_id>=selected_status_id)
                                                local_status_list.add(status);
                                          });
                                          Controller_Comment.clear();
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
                                                    "Order Status",
                                                    style: TextStyle(
                                                        color: Colors.blue
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content:  Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 20),
                                                    margin: EdgeInsets.only(left: 20,right: 20),
                                                    decoration: BoxDecoration(
                                                        border:Border.all(width: 2, color: Colors.blue),
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Center(
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<int>(
                                                            items: local_status_list.map((dropdownitem) {
                                                              return DropdownMenuItem(
                                                                child: Text("${dropdownitem.status}"),
                                                                value: dropdownitem.order_status_id,
                                                              );
                                                            }).toList(),
                                                            value: selected_status_id,
                                                            onChanged: (value) {
                                                              setState((){
                                                                this.selected_status_id = value;
                                                                if(selected_status_id==7)
                                                                  {
                                                                    is_reject =true;
                                                                  }
                                                                else
                                                                  {
                                                                    is_reject = false;
                                                                  }
                                                              });
                                                            },
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  //Comment
                                                  is_reject?
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
                                                          controller: Controller_Comment,
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
                                                              labelText: "Comment (Optional)",
                                                              errorStyle: TextStyle(fontSize: 15),
                                                              labelStyle:
                                                              TextStyle(color: Colors.blueAccent)),
                                                          focusNode: Focus_Node_Comment,
                                                          onFieldSubmitted: (value) {
                                                            Focus_Node_Comment.unfocus();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ):SizedBox(),
                                                  SizedBox(height: 20,),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 60),
                                                      child: RaisedButton(
                                                        color: Colors.blue,
                                                        onPressed: (){
                                                          _Update_Order_Status(widget.laundry_owner_id,orders_list[index], selected_status_id, is_reject?Controller_Comment.text.trim():"",);
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "Update",
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
                                      }
                                  ),
                                  SizedBox(width: 10,),
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
                                            "Service : ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            orders_list[index].order_service_name,
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
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "PickUp/Delivery Address: ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              orders_list[index].pickup_address,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider(),
                              ],
                            ),
                          ),
                        ),
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
_Update_Order_Status(int laundry_owner_id,Order order,int order_status,String comment,)async{
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
                    "Updating Order Status...\nPlease wait...",
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
        K_API_Initial_Address + "orders/updateOrderByOrderIdAndStatus",
        headers: headers,
        body: json.encode({
          "order":{
            "comment": comment,
            "laundry_owner_id": laundry_owner_id,
            "order_id" : order.order_id,
            "order_status": order_status
          }
        }));
    print("Body = ${response.body}");
    var data = json.decode(response.body);
    if (data["msg"]=="Order Updated Succesfully") {
      MyToast(msg: "Order Status Updated Successfully");

      // print("Current Status Id= ${status_list[order_status-1].status}");
      // print("Current Status = ${status_list[order_status-1].status}");
      _get_All_orders();
      twilioFlutter.sendSMS(
          toNumber: "${order.Customer_mobile_no}".trim(),
          messageBody:
          order_status!=2?
              "Dear Customer, Your Order no ${order.order_id} for ${order.Category} of "
              "${order.order_service_name} is ${status_list[order_status-1].status}. ${order.order_laundry_name}"
      :"Dear Customer, Your Order no ${order.order_id} for ${order.Category} of "
  "${order.order_service_name}'\s ${status_list[order_status-1].status}. ${order.order_laundry_name}");
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
