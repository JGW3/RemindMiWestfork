import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/modules/dependent_home_task/dependent_home_task_view.dart';
import 'package:remindmi/app/modules/home_task_list_page/home_task_list_view.dart';
import 'package:remindmi/app/modules/manage/manage_view.dart';
import 'package:remindmi/app/modules/navigation/bottom_navigation_controller.dart';

class BottomNavigationView extends StatelessWidget {
  final BottomNavigationController bottomNavigationBarController = Get.put(
    BottomNavigationController(),
  );
  BottomNavigationView({Key? key}) : super(key: key);
  final getStorge = GetStorage();

  final screens = [HomeTaskListViews(), ManageView()];
  final dependentscreens = [DependentHomeTaskListViews(), ManageView()];

  @override
  Widget build(BuildContext context) {
    if (getStorge.read('role') == 'parent') {
      return Scaffold(
        body: Obx(
          () => IndexedStack(
            index: bottomNavigationBarController.selectedIndex.value,
            children: screens,
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Color.fromARGB(255, 0, 74, 219),
            unselectedItemColor: Color.fromARGB(255, 169, 174, 183),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              bottomNavigationBarController.changeIndex(index);
            },
            currentIndex: bottomNavigationBarController.selectedIndex.value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled, size: 34),
                label: 'Home',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts, size: 34),
                label: 'Manage',
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Obx(
          () => IndexedStack(
            index: bottomNavigationBarController.selectedIndex.value,
            children: dependentscreens,
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Color.fromARGB(255, 0, 74, 219),
            unselectedItemColor: Color.fromARGB(255, 169, 174, 183),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              bottomNavigationBarController.changeIndex(index);
            },
            currentIndex: bottomNavigationBarController.selectedIndex.value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled, size: 34),
                label: 'Home',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts, size: 34),
                label: 'Manage',
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    }
  }
}
