import 'package:get/get.dart';

class MyController extends GetCupertinoApp {

  Rx<bool> isChangeGrid = false.obs;

  changeView(){
    isChangeGrid.value =! isChangeGrid.value;
  }
}