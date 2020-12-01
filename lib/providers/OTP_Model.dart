import 'package:flutter/cupertino.dart';
class Flutter_Otp with ChangeNotifier {
  int otp;
  //For Verification of Code
  void set_otp(int Otp_cod) {
    otp =Otp_cod;
    notifyListeners();
  }
}
