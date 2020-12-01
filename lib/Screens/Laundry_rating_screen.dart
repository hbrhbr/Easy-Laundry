import 'dart:convert';

import 'package:easy_laundry/Screens/Home_Screen.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class View_laundry_Owner_Rating_Reviews extends StatefulWidget {
  final int laundry_owner_id;
  // final String Customer_Name;
  // View_laundry_Owner_Rating_Reviews({this.laundry_owner_id,this.Customer_Name});
  View_laundry_Owner_Rating_Reviews({this.laundry_owner_id,});
  @override
  _View_laundry_Owner_Rating_ReviewsState createState() => _View_laundry_Owner_Rating_ReviewsState();
}
class Rating{
  int Laundry_owner_id;
  String Customer_Name;
  double rating;
  String review;
  Rating({this.review,this.Laundry_owner_id,this.Customer_Name,this.rating});
}
class _View_laundry_Owner_Rating_ReviewsState extends State<View_laundry_Owner_Rating_Reviews> {
  List<Rating>Rating_list = [];
  bool is_Loading = true;
  _get_Rating()async{
    setState(() {
      is_Loading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    print("Laundry Owner id = ${widget.laundry_owner_id}");
    var response = await http.post(
        K_API_Initial_Address+"orders/viewRatingsReviewsByLaundryOwner",
        headers: headers,
        body: json.encode({
          "laundry_owner_id":widget.laundry_owner_id,
        })
    );

    var data = json.decode(response.body);
    print("data  = ${data}");
    // print("data  = ${data["msg"]}");
    if(data["rating_reviews"].length==0)
    {
      setState(() {
        is_Loading= false;
      });
      return;
    }
    if(response.statusCode==200)
    {
      for(int i = 0;i<data['rating_reviews'].length;i++)
      {
        Rating_list.add(
            Rating(
              review: data['rating_reviews'][i]["reviews"],
              Customer_Name: "${data['rating_reviews'][i]["customer"]["first_name"]} ${data['rating_reviews'][i]["customer"]["last_name"]}",
              rating: double.parse(data['rating_reviews'][i]["rating"].toString()),
            ),
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
  @override void initState() {
    _get_Rating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rating & Reviews"),
      ),
      body: WillPopScope(
        onWillPop: ()async{
          return user.role==2?
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Home_Screen()))
              :true;
        },
        child: !is_Loading
            ?Rating_list.length==0
            ?Center(
            child: Text(
              "No Rating & Reviews",
              style: TextStyle(color: Colors.blue,fontSize: 25),
            ),
        )
            :ListView.builder(
            itemCount: Rating_list.length,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          Rating_list[index].Customer_Name,
                          style: TextStyle(color: Colors.blue,fontSize: 16),
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.star,color: Colors.amber,),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                            Rating_list[index].rating.toString(),
                            style: TextStyle(color: Colors.amber,fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Text(
                        Rating_list[index].review,
                      style: TextStyle(color: Colors.black,),
                    ),
                  ],
                ),
              );
            }
        ):
        Center(
          child: CircularProgressIndicator(
            strokeWidth: 6,
            backgroundColor: Colors.black87,
          ),
        ),
      ),
    );
  }
}
