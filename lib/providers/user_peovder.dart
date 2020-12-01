import 'package:flutter/cupertino.dart';
import 'package:easy_laundry/constants.dart';

class user_model with ChangeNotifier {
  // user = User();
  // laundry = Laundry_Owner();

  set_user_street_address(String street)
  {
    user.street_address = street;
    notifyListeners();
  }
  set_latlng(double latitude, double longitude)
  {
    user.latitude = latitude;
    user.longitude = longitude;
    notifyListeners();
  }
  set_user_city(String city)
  {
    user.city = city;
    notifyListeners();
  }
  set_user_state(String state)
  {
    user.state = state;
    notifyListeners();
  }
  set_user_country_name(String country) {
    user.country = country;
    notifyListeners();
  }
  set_user_role(int role_id) {
    user.role = role_id;
    notifyListeners();
  }
  set_Cnic(String image_front, int cnic ,String image_back)
  {
    laundry.CNIC_Image_back = image_back;
    laundry.CNIC_Image_front = image_front;
    laundry.user_cnic = cnic;
    notifyListeners();
  }
  set_password(String pass)
  {
    user.password = pass;
    notifyListeners();
  }

  set_Ntn(int NTN)
  {
    laundry.ntn_no = NTN;
    notifyListeners();
  }
  set_user_name(String name1, String name2) {
    user.first_name = name1;
    user.last_name = name2;
    notifyListeners();
  }

  set_user_email(String email) {
    user.email = email;
    notifyListeners();
  }

  set_user_country_code(String code) {
    user.user_country_code = code;
    notifyListeners();
  }
  set_user_phone(String phone) {
    user.mobile_no = phone;
    notifyListeners();
  }
  set_laundry_taxpayer(int is_taxpayer)
  {
    laundry.is_tax_filer = is_taxpayer;
    notifyListeners();
  }
  set_laundry_delivery(int is_delivery)
  {
    laundry.is_home_delivery = is_delivery;
    notifyListeners();
  }

}
