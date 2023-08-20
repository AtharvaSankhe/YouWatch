import 'package:get/get.dart';


class GlobalController extends GetxController{
  static GlobalController  get instance => Get.find() ;

  RxBool showProgessbar = false.obs;

}