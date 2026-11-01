import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/user_avatar.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/modules/avatar/avatar_editor_view.dart';
import 'package:remindmi/app/services/firestore_db.dart';

// Readable message for errors from callable Cloud Functions.
String functionError(Object e) {
  if (e is FirebaseFunctionsException) {
    if (e.code == 'not-found' || e.code == 'unavailable') {
      return 'This needs the RemindMi Cloud Functions deployed (see README).';
    }
    return e.message ?? e.code;
  }
  return e.toString();
}

// Asks for one line of text; returns null if cancelled.
Future<String?> askText(
  String title, {
  String initial = '',
  String? hint,
  bool obscure = false,
}) {
  final controller = TextEditingController(text: initial);
  return Get.dialog<String>(
    AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        obscureText: obscure,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        TextButton(
          onPressed: () => Get.back(result: controller.text.trim()),
          child: Text('Save'),
        ),
      ],
    ),
  );
}

// What a parent can do with one child: opened from Add Dependent's list.
void showChildOptions(String childUid, String name) {
  Future<void> run(String done, Future<void> Function() action) async {
    try {
      await action();
      showCustomSnackBarSuccess(done, title: 'Done');
    } catch (e) {
      showCustomSnackBar(functionError(e), title: 'Error');
    }
  }

  Get.bottomSheet(
    backgroundColor: Colors.white,
    SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: UserAvatar(uid: childUid, radius: 20),
            title: Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Change avatar'),
            onTap: () {
              Get.back();
              Get.to(() => AvatarEditorView(uid: childUid, name: name));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Rename'),
            onTap: () async {
              Get.back();
              final newName = await askText('Rename $name', initial: name);
              if (newName == null || newName.isEmpty || newName == name) return;
              await run(
                'Renamed to $newName',
                () => FireStoreDB().renameUser(childUid, newName),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.password),
            title: Text('Set a new password'),
            onTap: () async {
              Get.back();
              final password = await askText(
                'New password for $name',
                hint: 'At least 6 characters',
                obscure: true,
              );
              if (password == null || password.isEmpty) return;
              await run(
                'Password changed',
                () => FireStoreDB().setChildPassword(childUid, password),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_remove, color: Colors.red),
            title: Text('Remove $name', style: TextStyle(color: Colors.red)),
            subtitle: Text(
              'Deletes their account and takes them off all tasks',
            ),
            onTap: () async {
              Get.back();
              final sure = await Get.dialog<bool>(
                AlertDialog(
                  title: Text('Remove $name?'),
                  content: Text(
                    'Their account is deleted and they are taken off every task. '
                    'Turn-taking tasks pass to the next child. This can\'t be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (sure != true) return;
              await run(
                '$name was removed',
                () => FireStoreDB().deleteChild(childUid),
              );
            },
          ),
        ],
      ),
    ),
  );
}
