class appointment{
  int appointment_id;
  int los;
  int customer_id;
  int laundry_owner_id;
  int quantity;
  int total_price;
  String appointment_time;
  appointment({
    this.laundry_owner_id,
    this.total_price,
    this.customer_id,
    this.appointment_id,
    this.appointment_time,
    this.los,
    this.quantity,
});
}
class Order{
  int order_id;
  int order_qty;
  String order_service_name;
  int order_price;
  String Order_status;
  int order_status_id;
  String order_laundry_name;
  String Customer_name;
  String Category;
  String pickup_address;
  String Customer_mobile_no;
  String Laundry_Owner_Mobile_no;
  String Comment;
  int Laundry_owner_id;
  Order({
    this.order_id,
    this.order_laundry_name,
    this.order_price,
    this.order_qty,
    this.order_service_name,
    this.Order_status,
    this.order_status_id,
    this.Category,
    this.Customer_name,
    this.pickup_address,
    this.Customer_mobile_no,
    this.Comment,
    this.Laundry_owner_id,
    this.Laundry_Owner_Mobile_no,
});
}

class Order_Status{
  int order_status_id;
  String status;
  Order_Status({this.order_status_id,this.status});
}
class Appointment_Status{
  int Appointment_status_id;
  String Appointment_status;
  Appointment_Status({this.Appointment_status,this.Appointment_status_id});
}
class Appointment{
  int appointment_id;
  int appointment_qty;
  String appointment_service_name;
  int appointment_price;
  String appointment_status;
  int appointment_status_id;
  String appointment_laundry_name;
  String Customer_name;
  String Category;
  String appointment_time;
  String Customer_mobile_no;
  String Laundry_Owner_Mobile_no;
  String Comment;
  int Laundry_owner_id;
}