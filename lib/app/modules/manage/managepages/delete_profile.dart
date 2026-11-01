//Delete profile button

import 'package:flutter/material.dart';

class DeleteProfilePage extends StatefulWidget {
  @override
  _DeleteProfilePageState createState() => _DeleteProfilePageState();
}

class _DeleteProfilePageState extends State<DeleteProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
