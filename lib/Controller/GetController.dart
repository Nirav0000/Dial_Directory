import 'package:get/get.dart';

class MyController extends GetCupertinoApp {

  Rx<bool> isChangeGrid = false.obs;

  changeView(){
    isChangeGrid.value =! isChangeGrid.value;
  }


  // Favorite Screen

  Rx<bool> isChangeGrid_Fav = false.obs;

  changeView_Fav(){
    isChangeGrid.value =! isChangeGrid.value;
  }

// Edit Screen



}