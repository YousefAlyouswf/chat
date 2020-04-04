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
  double titleFontSize;
  Color titleColor;
  double headline;
  Color headlineColor;
  void colors() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('colors').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((data) {
      String valueAppColor = data['appColor'];
      String valueHeadLineColor = data['headlineColor'];
      String valueTitle = data['titleColor'];
      int valueApp = int.parse(valueAppColor, radix: 16);
      int valueHeadline = int.parse(valueHeadLineColor, radix: 16);
      int valuetitleColor = int.parse(valueTitle, radix: 16);
      titleFontSize = double.parse(data['titleFontSize']);
      headline = double.parse(data['headline']);
      setState(() {
        appColor = new Color(valueApp);
        headlineColor = new Color(valueHeadline);
        titleColor = new Color(valuetitleColor);
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
        textTheme: TextTheme(
          headline: TextStyle(
              fontSize: headline,
              color: headlineColor,
              fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: titleFontSize,
              color: titleColor,
              fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 18.0),
        ),
      ),
      home: Loading(),
    );
  }
}
