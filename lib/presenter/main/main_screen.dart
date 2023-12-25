import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/menu.dart';
import 'package:orm_library_manager/presenter/common/common_menu_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('도서 관리 프로그램')),
      body: CommonMenuScreen(menu: mainMenuMap),
    );
  }
}
