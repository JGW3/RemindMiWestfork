import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/child_options_sheet.dart';
import 'package:remindmi/app/helper/session.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/services/firestore_db.dart';

// Deletes the signed-in account. For a parent this removes the whole family:
// every child account and every task (functions/children.js deleteMyAccount).
class DeleteProfilePage extends StatefulWidget {
  @override
  _DeleteProfilePageState createState() => _DeleteProfilePageState();
}

class _DeleteProfilePageState extends State<DeleteProfilePage> {
  final confirm = TextEditingController();
  bool deleting = false;

  Future<void> delete() async {
    setState(() => deleting = true);
    try {
      await FireStoreDB().deleteMyAccount();
      await signOut(unregisterPush: false);
    } catch (e) {
      showCustomSnackBar(functionError(e), title: 'Error');
      if (mounted) setState(() => deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isParent = GetStorage().read('role') == 'parent';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Delete Profile',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            isParent
                ? 'This deletes your account, all of your children\'s accounts, '
                      'and every task. It can\'t be undone.'
                : 'This deletes your account and takes you off every task. '
                      'It can\'t be undone.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          TextField(
            controller: confirm,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Type DELETE to confirm',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: deleting || confirm.text.trim() != 'DELETE'
                  ? null
                  : delete,
              child: deleting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Delete my account'),
            ),
          ),
        ],
      ),
    );
  }
}
