import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/sidebar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              Sidebar(),
              Expanded(
                child: IndexedStack(
                  index: controller.selectedIndex,
                  children: controller.pages,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
