class User
{
  int role;
  String user_country_iso_code;
  String first_name;
  String last_name;
  String email;
  String mobile_no;
  String user_country_code;
  String country;
  String password;
  String city;
  String state;
  String street_address;
  double latitude;
  double longitude;
  int user_id;
  //Constructor
  User({
    this.user_country_code,
    this.role,
    this.user_id,
    this.email,
    this.first_name,
    this.last_name,
    this.mobile_no,
    this.country,
    this.password,
    this.state,
    this.longitude,
    this.latitude,
    this.street_address,
    this.city,
  });
}