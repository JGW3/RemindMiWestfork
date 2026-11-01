import 'package:flutter/material.dart';
import 'package:remindmi/app/widget/manage_card.dart';
import 'package:remindmi/app/modules/manage/managepages/delete_profile.dart';
import 'package:remindmi/app/modules/manage/managepages/edit_profile.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 226, 226),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: ManageCard(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditProfilePage();
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ManageCard(
              icon: Icons.delete,
              title: 'Delete Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DeleteProfilePage();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
