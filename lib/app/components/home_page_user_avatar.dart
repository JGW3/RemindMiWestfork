import 'package:remindmi/app/components/user_avatar.dart';
import 'package:flutter/material.dart';

class HomePageUserAvatar extends StatelessWidget {
  // When set, shows that family member's avatar instead of the placeholder
  final String? uid;

  const HomePageUserAvatar({super.key, this.uid});

  @override
  Widget build(BuildContext context) {
    if (uid != null) return UserAvatar(uid: uid!, radius: 12);
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
