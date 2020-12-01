import 'dart:convert';
import 'file:///C:/Users/HBR/OneDrive/easy_laundry/lib/Screens/Search_View_Laundry_Screens/veiw_selected_laundry_profile.dart';
import 'package:easy_laundry/Widgets/myToast.dart';
import 'package:easy_laundry/constants.dart';
import 'package:easy_laundry/models/User_model.dart';
import 'package:easy_laundry/models/user_laundry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class Search_Laundry extends StatefulWidget {
  @override
  _Search_LaundryState createState() => _Search_LaundryState();
}

class _Search_LaundryState extends State<Search_Laundry> {
  TextEditingController Controller_laundry_owner_name = TextEditingController();
  FocusNode Focus_laundry_name;
  bool is_loading = true;
  List<User>user_list = [];
  List<Laundry_Owner>laundry_list = [];
  Future<void>_get_all_Laundry_Owner_Details()async{
    setState(() {
      is_loading =true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    try{
      var response = await http.post(
          K_API_Initial_Address+"users/getAllLaundryOwners",
          headers: headers,
          body: json.encode({})
      );
      var data = json.decode(response.body);
      // MyToast(msg:"${data}");
      print("Data = ${data['laundryOwners'][0]}");
      List<dynamic>a= data["laundryOwners"];
      if(response.statusCode==200)
      {
        for(int i = 0; i<a.length;i++)
        {
          print("value of i = ${i+1}");
          var addr = a[i]["address"];
          print("Address = $addr");
          laundry_list.add(
              Laundry_Owner(
                user_cnic: int.parse(addr["cnic_no"]),
                ntn_no: a[i]['address']["ntn_no"]!="null"?int.parse(a[i]['address']["ntn_no"]):null,
                laundry_type: a[i]['address']["lundry_type"],
                laundry_name: a[i]['address']["laundry_name"],
                is_tax_filer: a[i]['address']["is_tax_filer"],
                is_home_delivery: a[i]['address']["is_home_delivery"],
              )
          );
          user_list.add(
              User(
                user_id: a[i]["user_id"],
                role: a[i]['role'],
                first_name:a[i]['first_name'] ,
                last_name: a[i]['last_name'],
                email: a[i]['email'],
                latitude: a[i]['address']["latitude"]!=null
                    ? double.parse(a[i]['address']["latitude"])
                    :null,
                longitude: a[i]['address']["longitude"]!=null
                    ?double.parse(a[i]['address']["longitude"])
                    :null,
                mobile_no: a[i]['mobile_no'],
                country: a[i]['address']["country"],
                city: a[i]['address']["city"],
                state: a[i]['address']["state"],
                street_address: a[i]['address']["street_address"],
              )
          );
        }
        print("Laundry list length = ${laundry_list.length}");
        print("User list length = ${user_list.length}");
        setState(() {
          is_loading = false;
        });
      }
      else{
        MyToast(msg:"Failed to get data \n Please try again");
        Navigator.pop(context);
      }
    }catch(e)
    {
      MyToast(msg:"Failed to get data \n Please try again");
      print("Exception = $e");
      Navigator.pop(context);
    }
  }

  Future<void>_search_LaundryByName()async{
    setState(() {
      is_loading =true;
    });
    Focus_laundry_name.unfocus();
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'
    };
    var response = await http.post(
        K_API_Initial_Address+"users/getAllLaundryOwnersByName",
        headers: headers,
        body: json.encode({
          "laundryName":Controller_laundry_owner_name.text,
        })
    );
    var data = json.decode(response.body);
    // MyToast(msg:"${data}");
    print("Data = ${data['laundryOwners']}");
    List<dynamic>a= data["laundryOwners"];
    if(response.statusCode==200)
    {
      for(int i = 0; i<a.length;i++) {
        print("value of i = ${i + 1}");
        laundry_list.add(
            Laundry_Owner(
              user_cnic: int.parse(a[i]["address"]["cnic_no"]),
              ntn_no: a[i]['address']["ntn_no"] != "null" ? int.parse(
                  a[i]['address']["ntn_no"]) : null,
              laundry_type: a[i]['address']["lundry_type"],
              laundry_name: a[i]['address']["laundry_name"],
              is_tax_filer: a[i]['address']["is_tax_filer"],
              is_home_delivery: a[i]['address']["is_home_delivery"],
            )
        );
        user_list.add(
            User(
              user_id: a[i]["user_id"],
              role: a[i]['role'],
              first_name: a[i]['first_name'],
              last_name: a[i]['last_name'],
              email: a[i]['email'],
              latitude: a[i]['address']["latitude"] != null
                  ? double.parse(a[i]['address']["latitude"])
                  : null,
              longitude: a[i]['address']["longitude"] != null
                  ? double.parse(a[i]['address']["longitude"])
                  : null,
              mobile_no: a[i]['mobile_no'],
              country: a[i]['address']["country"],
              city: a[i]['address']["city"],
              state: a[i]['address']["state"],
              street_address: a[i]['address']["street_address"],
            )
        );
      }
      print("Laundry list length = ${laundry_list.length}");
      print("User list length = ${user_list.length}");
      setState(() {
        is_loading = false;
      });
    }
    else{
      MyToast(msg:"Failed to get data \n Please try again");
      setState(() {
        is_loading = false;
      });
    }
  }
  @override void initState() {
    Focus_laundry_name = FocusNode();
    _get_all_Laundry_Owner_Details();
    super.initState();
  }
  bool is_result = false;
  int selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Laundry"),
      ),
      body: WillPopScope(
          child: Stack(
            children: [
              Column(
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
                              controller: Controller_laundry_owner_name,
                              toolbarOptions: ToolbarOptions(
                                  cut: true, paste: true, selectAll: true),
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search,color: Colors.blue,),
                                  tooltip: "Search",
                                  onPressed: ()async{
                                    user_list.clear();
                                    laundry_list.clear();
                                    Focus_laundry_name.unfocus();
                                    await _search_LaundryByName();
                                  },
                                ),
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  labelText: "Laundry Name",
                                  errorStyle: TextStyle(fontSize: 15),
                                  labelStyle:
                                  TextStyle(color: Colors.blueAccent)),
                              focusNode: Focus_laundry_name,
                              onFieldSubmitted: (value) {
                                Focus_laundry_name.unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue,width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: laundry_list.length==0&&!is_loading?
                            Center(child: Text("No Record Found",style: TextStyle(color: Colors.blue,fontSize: 25),),)
                             :ListView.builder(
                              key: Key('builder ${selected.toString()}'),
                                itemCount: laundry_list.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Laundry Name
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
                                                title: Padding(
                                                  padding: const EdgeInsets.only(left: 10,top: 5),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Laundry Name:",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 12,
                                                                color: Colors.blue
                                                            ),
                                                          ),
                                                          Text(
                                                            "${laundry_list[index].laundry_name}",
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                                fontSize: 10
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5,),
                                                      InkWell(
                                                        child: Text(
                                                            "View Profile",
                                                          style: TextStyle(color: Colors.blue,fontSize: 12),
                                                        ),
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>view_selected_profile(user_id: user_list[index].user_id,)));
                                                        },
                                                      ),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                  ),
                                                ),
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [Text(
                                                            "Laundry Owner: ",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                            Text(
                                                              user_list[index].first_name+user_list[index].last_name,
                                                              style: TextStyle(fontSize: 10),
                                                            ),],
                                                        ),

                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Street Address: ",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                            Text(
                                                              user_list[index].street_address,
                                                              style: TextStyle(fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "City: ",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                            Text(
                                                              user_list[index].city,
                                                              style: TextStyle(fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Mobile No: ",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                            Text(
                                                              user_list[index].mobile_no,
                                                              style: TextStyle(fontSize: 10),
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
                                }
                            )

                          ),
                      ),
                    ],
                ),
              !is_loading?
              SizedBox()
                  :Center(
                child: CircularProgressIndicator(strokeWidth: 6,backgroundColor: Colors.black87,),
              )
            ],
          ),
      ),
    );
  }
}
