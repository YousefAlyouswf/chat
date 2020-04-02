import 'package:cloud_firestore/cloud_firestore.dart';
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

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color appColor;

  void colors() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('colors').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((data) {
      String valueString = data['appColor'];
      
      int value = int.parse(valueString, radix: 16);
      setState(() {
        appColor = new Color(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    colors();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: appColor,
      ),
      home: Loading(),
    );
  }
}
