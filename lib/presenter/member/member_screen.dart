import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/menu.dart';
import 'package:orm_library_manager/presenter/common/common_menu_screen.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 메뉴'),
      ),
      body: CommonMenuScreen(menu: memberMenuMap),
    );
  }
}
