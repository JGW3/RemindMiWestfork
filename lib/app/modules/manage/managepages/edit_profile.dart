import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/child_options_sheet.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/modules/avatar/avatar_editor_view.dart';
import 'package:remindmi/app/services/firestore_db.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final storage = GetStorage();
  late final name = TextEditingController(text: storage.read('fullName'));
  bool saving = false;

  Future<void> save() async {
    final newName = name.text.trim();
    if (newName.isEmpty) {
      showCustomSnackBar('Name can\'t be empty', title: 'Error');
      return;
    }
    setState(() => saving = true);
    try {
      await FireStoreDB().renameUser(storage.read('id'), newName);
      Get.back();
      showCustomSnackBarSuccess('Profile updated', title: 'Saved');
    } catch (e) {
      showCustomSnackBar(functionError(e), title: 'Error');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          Text(
            storage.read('email') ?? '',
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Get.to(
              () => AvatarEditorView(
                uid: storage.read('id'),
                name: storage.read('fullName'),
              ),
            ),
            icon: Icon(Icons.face),
            label: Text('Change avatar'),
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: saving ? null : save,
              child: saving ? CircularProgressIndicator() : Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
