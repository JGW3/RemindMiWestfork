import 'package:flutter/material.dart';

class HomePageUserAvatar extends StatelessWidget {
  const HomePageUserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 24,
        width: 24,
        color: Colors.blue,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 101, 152, 254),
            radius: 30,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 11,
              child: Image.asset('assets/images/child.png'),
            ),
          ),
        ),
      ),
    );
  }
}
