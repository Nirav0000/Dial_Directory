import 'package:caller_app/Constent/Colors.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Calling Code Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            country == null
                ? Container()
                : Column(
              children: <Widget>[
                Image.asset(
                  country.flag,
                  package: countryCodePackageName,
                  width: 100,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '${country.callingCode} ${country.name} (${country.countryCode})',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              child: Text('Select Country using full screen'),
              color: Colors.amber,
              onPressed: _onPressed,
            ),
            SizedBox(height: 24,),
            MaterialButton(
              child: Text('Select Country using bottom sheet'),
              color: Colors.orange,
              onPressed: _onPressedShowBottomSheet,
            ),
            SizedBox(height: 24,),
            MaterialButton(
              child: Text('Select Country using dialog'),
              color: Colors.deepOrangeAccent,
              onPressed: _onPressedShowDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() async {
    final country =
    await Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PickerPage();
    }));
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  void _onPressedShowDialog() async {
    final country = await showCountryPickerDialog(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }
}

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text('Select Country'),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        child: CountryPickerWidget(
          onSelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}