import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_list_screen.dart';
import 'package:orm_library_manager/presenter/member/member_list_screen.dart';

class BorrowMainScreen extends StatefulWidget {
  const BorrowMainScreen({super.key});

  @override
  State<BorrowMainScreen> createState() => _BorrowMainScreenState();
}

class _BorrowMainScreenState extends State<BorrowMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대출 관리'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('1. 도서 대출'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MemberListScreen(mode: ScreenMode.selector)),
              );
            },
          ),
          ListTile(
            title: const Text('2. 대출 반납'),
            onTap: () {

            },
          ),
          ListTile(
            title: const Text('3. 대출 연장'),
            onTap: () {

            },
          ),
          ListTile(
            title: const Text('4. 대출 현황'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BorrowListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
