import 'dart:convert';

import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
class View_Financial_Details extends StatefulWidget {
  @override
  _View_Financial_DetailsState createState() => _View_Financial_DetailsState();
}

class _View_Financial_DetailsState extends State<View_Financial_Details> {
  bool is_Loading = true;
  int earning;
  int spending;

  Future<void>_get_financial_details()async{
    is_Loading=true;
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(
      K_API_Initial_Address+"financialDetails/getFinancialDetailsByUserId",
      headers: headers,
      body: json.encode({
        "user_id" : user.user_id,
      }),
    );
    var data = json.decode(response.body);
    print("Data = $data");
    if(response.statusCode==200) {
      earning = data['financial_details']['total_earning'];
      spending = data['financial_details']['total_spending'];
      setState(() {
        is_Loading= false;
      });
    }else
      {
        MyToast(msg: "Failed to get details \n Please try again ");
        setState(() {
          is_Loading= false;
        });
        Navigator.pop(context);
      }
  }

  @override void initState() {
    super.initState();
    _get_financial_details();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Details"),
      ),
      body: WillPopScope(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: !is_Loading
          ?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Text("Total Earnings",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue),),
              SizedBox(height: 15,),
              Text("Rs.$earning",style: TextStyle(fontSize: 25,color: Colors.black),),
              SizedBox(height: 40,),
              Text("Total Spendings",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blue),),
              SizedBox(height: 15,),
              Text("Rs.$spending",style: TextStyle(fontSize: 25,color: Colors.black),),
              Expanded(child: SizedBox()),
            ],
          )
          :Center(
            child: CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
