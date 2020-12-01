import 'package:easy_laundry/models/User_model.dart';
import 'package:easy_laundry/models/order_model.dart';
import 'package:easy_laundry/models/user_laundry.dart';
import 'package:flutter/cupertino.dart';

Color primary_color = Color(0xFF3698CF);
String K_API_Initial_Address = "https://easylaundry.softcept.net/";

User user = User();
Laundry_Owner laundry = Laundry_Owner();
String User_Loc = "";
// appointment_new= data["new_appointment"];
// appointment_accepted= data["appointment_accepted"];
// appointment_in_progress= data["appointment_in_progress"];
// appointment_completed= data["appointment_completed"];
// appointment_rejected= data["appointment_rejected"];
List<Appointment_Status>appointment_list = [
  Appointment_Status(
    Appointment_status_id: 1,
    Appointment_status: "new_appointment",
  ),
  Appointment_Status(
    Appointment_status_id: 2,
    Appointment_status: "appointment_accepted",
  ),
  Appointment_Status(
    Appointment_status_id: 3,
    Appointment_status: "appointment_in_progress",
  ),
  Appointment_Status(
    Appointment_status_id: 4,
    Appointment_status: "appointment_completed",
  ),
  Appointment_Status(
    Appointment_status_id: 5,
    Appointment_status: "appointment_rejected",
  ),
];

List<Order_Status>status_list = [
  Order_Status(
    order_status_id: 1,
    status: "Request For Pickup",
  ),
  Order_Status(
    order_status_id: 2,
    status: "Request Accepted",
  ),
  Order_Status(
    order_status_id: 3,
    status: "Picked",
  ),
  Order_Status(
    order_status_id: 4,
    status: "In Progress",
  ),
  Order_Status(
    order_status_id: 5,
    status: "Ready for delivery",
  ),
  Order_Status(
    order_status_id: 6,
    status: "Delivered",
  ),
  Order_Status(
    order_status_id: 7,
    status: "Rejected",
  ),
];