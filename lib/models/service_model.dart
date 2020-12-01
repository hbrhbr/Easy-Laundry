class Laundry_Owner_Service{
  int los_id;
  int service_charges;
  String service_Description;
  int Laundry_service_id;
  String laundry_owner_service_name;
  Laundry_Owner_Service({this.service_charges,this.service_Description,this.los_id,this.laundry_owner_service_name,this.Laundry_service_id});
}
class Laundry_Service{
  int Laundry_service_id;
  String Laundry_service_name;
  int category_id;
  Laundry_Service({this.category_id,this.Laundry_service_id,this.Laundry_service_name});
}