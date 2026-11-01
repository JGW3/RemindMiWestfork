//Credits page

import 'package:flutter/material.dart';

class CreditsPage extends StatefulWidget {
  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
        title: Text(
          'Credits',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 150.0),
        child: Text(
          "Created by Nikhil Adhikari, Daniel Derheim, Bishnu Sharma, and John West.",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
