import 'package:get/get.dart';

class Logingetx extends GetxController {
  RxBool isshow = true.obs;
  void isvisibility() {
    isshow.value = !isshow.value;
  }
}
