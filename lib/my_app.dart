import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kanban Board',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.kanbanBoard,
      getPages: AppRoutes.pages,
    );
  }
}
