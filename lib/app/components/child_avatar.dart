import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;
  
  const ChildAvatar({
    super.key,
    this.radius = 25.0,
    this.imageUrl,
    this.showBorder = false,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showBorder ? BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ) : null,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : const AssetImage('assets/images/child.png') as ImageProvider,
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}