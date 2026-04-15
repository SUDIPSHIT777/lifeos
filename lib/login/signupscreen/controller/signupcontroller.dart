import 'package:get/get.dart';

class Signupcontroller extends GetxController {
  RxBool isshow = true.obs;
  RxBool ischeck = false.obs;
  void isvisibilitysignup() {
    isshow.value = !isshow.value;
  }
  void ischeckon(){
    ischeck.value=!ischeck.value;
  }
}
