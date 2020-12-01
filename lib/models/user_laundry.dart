class Laundry_Owner{
  int user_cnic;
  int ntn_no;
  String CNIC_Image_front;
  String CNIC_Image_back;
  String laundry_name;
  String laundry_type;
  int is_home_delivery;
  int is_tax_filer;
  

  Laundry_Owner({ 
    this.ntn_no,  
    this.user_cnic,  
    this.CNIC_Image_front,
    this.CNIC_Image_back,
    this.is_home_delivery,
    this.is_tax_filer,
    this.laundry_name,  
    this.laundry_type,
  });
}