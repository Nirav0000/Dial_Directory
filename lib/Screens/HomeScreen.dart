import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../Constent/Colors.dart';
import '../Controller/GetController.dart';

class HomeTab extends StatefulWidget {
   HomeTab({super.key, this.controller});
  final ScrollController? controller;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var homeController = Get.put(MyController());

   final _shoppingBox = Hive.box('shopping_box');

   List<Map<String, dynamic>> _items = [];

   List? _contacts;

   final List<Map> myProducts =
   List.generate(100, (index) => {"id": index, "name": "Product $index"})
       .toList();

   Future<void> _createItem(Map<String, dynamic> newItem) async {
     await _shoppingBox.add(newItem);
     _refreshItems(); // update the UI
   }

   void getphoneDate() async {
     if (await FlutterContacts.requestPermission()) {
       _contacts = await FlutterContacts.getContacts(
           withThumbnail: true,
           withProperties: true,
           withPhoto: true,
           withAccounts: true);

       // DBdata = true;
       // final prefs = await SharedPreferences.getInstance();
       // prefs.setBool("SAVE", DBdata);
     }
   }

   void _refreshItems() {
     final data = _shoppingBox.keys.map((key) {
       final value = _shoppingBox.get(key);
       return {
         "key": key,
         "name": value["name"],
         "phone": value['phone'],
         "image": value['image']
       };
     }).toList();

     setState(() {
       _items = data.toList();
       // Storage_.read('oneTime') == null
       //     ? Storage_.read('contact')
       //     :
       //     _filteredContacts = _items;
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(100)
            ),
            child: Obx(
                  () =>  Center(
                child: IconButton(onPressed: (){
                  homeController.changeView();
                }, icon: Image(image: AssetImage(homeController.isChangeGrid.value==false?'assets/images/grid.png':'assets/images/list.png'))),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () =>  homeController.isChangeGrid.value==true?ListView.builder(
            controller: widget.controller,
            itemBuilder: (context, index) {
            return Card(
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(index.toString()),
                ),
              ),
            );
          },):
          GridView.builder(
              controller: widget.controller,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: _items.length,
              itemBuilder: (BuildContext ctx, i) {
                // _items.removeWhere((item) => item['name']==null && item['phone']);
                // _items.sort((a, b) {
                //   String nameA = a['name'] ?? '';
                //   String nameB = b['name'] ?? '';
                //
                //   // If either contact has no name, move it to the end
                //   if (nameA.isEmpty && nameB.isNotEmpty) {
                //     return 1;
                //   } else if (nameA.isNotEmpty &&
                //       nameB.isEmpty) {
                //     return -1;
                //   }
                //
                //   // Otherwise, sort based on the names
                //   return nameA.compareTo(nameB);
                // });
                final currentItem = _items[i];
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(currentItem['name']),
                );
              }),
        ),
      ),
    );
  }
}






