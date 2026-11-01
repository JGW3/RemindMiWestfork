import 'package:flutter/material.dart';

class ManageCard extends StatelessWidget {
  const ManageCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(width: 16),
              Icon(icon, color: Colors.blue, size: 36),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 218, 218, 218),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
