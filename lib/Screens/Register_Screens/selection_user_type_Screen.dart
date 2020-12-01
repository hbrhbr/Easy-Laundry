import 'package:easy_laundry/Screens/Register_Screens/user_basic_info_screen.dart';
import 'package:easy_laundry/providers/user_peovder.dart';
import 'package:flutter/material.dart';
import 'package:easy_laundry/constants.dart';
import 'package:provider/provider.dart';

class User_Type_Screen extends StatefulWidget {
  @override
  _User_Type_ScreenState createState() => _User_Type_ScreenState();
}

class _User_Type_ScreenState extends State<User_Type_Screen> {
  @override
  Widget build(BuildContext context) {
    var user_provider = Provider.of<user_model>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.99,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "Choose who you are?",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: primary_color,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  //Laundry Owner
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          user_provider.set_user_role(2);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) =>User_basic_info_Page()));
                        },
                        child: Column(
                          children: [
                            Text(
                              "Laundry Owner",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primary_color,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: primary_color, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    child: Image.asset(
                                        "images/laundry.jpg",
                                        fit: BoxFit.fill)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  //Customer
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          user_provider.set_user_role(3);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) =>
                                      User_basic_info_Page()));
                        },
                        child: Column(
                          children: [
                            Text(
                              "Customer",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primary_color,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: primary_color, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    child: Image.asset(
                                        "images/customer.jpg",
                                        fit: BoxFit.fill)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
