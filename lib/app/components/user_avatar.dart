import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/models/avatar.dart';
import 'package:remindmi/app/services/family_service.dart';

// A family member's avatar (emoji or photo) inside the app's blue ring.
class UserAvatar extends StatelessWidget {
  final String uid;
  final double radius;

  const UserAvatar({Key? key, required this.uid, this.radius = 32})
    : super(key: key);

  // Decoding base64 on every rebuild is wasteful; keep the latest per user.
  static final _photoCache = <String, MapEntry<String, Uint8List>>{};

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avatar = Avatar.fromUser(uid, FamilyService.to.users[uid]);
      return AvatarCircle(
        avatar: avatar,
        radius: radius,
        photo: _photo(avatar),
      );
    });
  }

  Uint8List? _photo(Avatar avatar) {
    if (avatar.photo == null) return null;
    final cached = _photoCache[uid];
    if (cached != null && cached.key == avatar.photo) return cached.value;
    final bytes = avatar.photoBytes!;
    _photoCache[uid] = MapEntry(avatar.photo!, bytes);
    return bytes;
  }
}

// Draws an Avatar; also used by the editor to preview unsaved changes.
class AvatarCircle extends StatelessWidget {
  final Avatar avatar;
  final double radius;
  final Uint8List? photo;

  const AvatarCircle({
    Key? key,
    required this.avatar,
    required this.radius,
    this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bytes = photo ?? avatar.photoBytes;
    return CircleAvatar(
      backgroundColor: Color.fromARGB(255, 101, 152, 254),
      radius: radius,
      child: CircleAvatar(
        radius: radius - (radius > 16 ? 2 : 1),
        backgroundColor: Color(avatar.color),
        backgroundImage: bytes == null ? null : MemoryImage(bytes),
        child: bytes == null
            ? Text(avatar.emoji, style: TextStyle(fontSize: radius))
            : null,
      ),
    );
  }
}
