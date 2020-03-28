
import 'package:flutter/material.dart';
import 'package:ipfinder/ipfinder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading.dart';

void main() {
  getCountry();
  runApp(MyApp());
}

void getCountry() async {
  Ipfinder ipfinder = Ipfinder('b22bfa0edbe8bf00fe3cde41e567fa824fc33688');
  IpResponse auth = await ipfinder.authentication();
  // print(auth.toJson());
  print(auth.countryName);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('country', auth.countryName.toString());
  prefs.setString('code', auth.countryCode.toLowerCase());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Loading(),
    );
  }
}
