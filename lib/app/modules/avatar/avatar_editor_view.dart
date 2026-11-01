import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remindmi/app/components/user_avatar.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/models/avatar.dart';
import 'package:remindmi/app/services/family_service.dart';
import 'package:remindmi/app/services/firestore_db.dart';

// Edit one person's avatar. Opened for yourself (Manage → My avatar, or the
// avatar on the home screen) or, for parents, a child (Add Dependent → tap a
// child). Parents and children can both change a child's avatar; last save wins.
class AvatarEditorView extends StatefulWidget {
  final String uid;
  final String name;

  const AvatarEditorView({super.key, required this.uid, required this.name});

  @override
  State<AvatarEditorView> createState() => _AvatarEditorViewState();
}

class _AvatarEditorViewState extends State<AvatarEditorView> {
  late Avatar draft = Avatar.fromUser(
    widget.uid,
    FamilyService.to.users[widget.uid],
  );
  bool saving = false;

  Future<void> pickPhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 70,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      // Keeps the user doc well under Firestore's 1 MB limit
      if (bytes.length > 300 * 1024) {
        showCustomSnackBar('That photo is too large', title: 'Photo');
        return;
      }
      setState(() => draft = draft.copyWith(photo: base64Encode(bytes)));
    } catch (e) {
      showCustomSnackBar('Couldn\'t open photos: $e', title: 'Photo');
    }
  }

  Future<void> save() async {
    setState(() => saving = true);
    try {
      await FireStoreDB().setAvatar(widget.uid, draft);
      Get.back();
      showCustomSnackBarSuccess('Avatar updated', title: 'Saved');
    } catch (e) {
      showCustomSnackBar(e.toString(), title: 'Error');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Widget sectionTitle(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      text,
      style: GoogleFonts.dmSans(fontSize: 22.0, fontWeight: FontWeight.w700),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          '${widget.name}\'s avatar',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 24),
          Center(child: AvatarCircle(avatar: draft, radius: 64)),
          sectionTitle('Photo'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => pickPhoto(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Choose photo'),
                ),
                OutlinedButton.icon(
                  onPressed: () => pickPhoto(ImageSource.camera),
                  icon: Icon(Icons.photo_camera),
                  label: Text('Take photo'),
                ),
                if (draft.photo != null)
                  TextButton.icon(
                    onPressed: () => setState(
                      () => draft = draft.copyWith(clearPhoto: true),
                    ),
                    icon: Icon(Icons.delete_outline),
                    label: Text('Use emoji instead'),
                  ),
              ],
            ),
          ),
          sectionTitle('Emoji'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final emoji in Avatar.emojis)
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => setState(
                      () => draft = draft.copyWith(
                        emoji: emoji,
                        clearPhoto: true,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          draft.photo == null && draft.emoji == emoji
                          ? Color.fromARGB(255, 101, 152, 254)
                          : Colors.grey[200],
                      child: Text(emoji, style: TextStyle(fontSize: 24)),
                    ),
                  ),
              ],
            ),
          ),
          sectionTitle('Color'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final color in Avatar.colors)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () =>
                        setState(() => draft = draft.copyWith(color: color)),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(color),
                      child: draft.color == color
                          ? Icon(Icons.check, color: Colors.black87)
                          : null,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 32, 20, 38),
            height: 60,
            child: RawMaterialButton(
              fillColor: Color.fromRGBO(24, 90, 219, 1.0),
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: saving ? null : save,
              child: saving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Save',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
