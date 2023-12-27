import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 75.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                  onPressed: () => context.push(Uri(path: '/borrow/member').toString()),
                  icon: const Icon(Icons.library_add, size: 75),
                  label: const Text('도서대출', style: TextStyle(fontSize: 25))),
              TextButton.icon(
                  onPressed: () => context.push(Uri(path: '/borrow/return').toString()),
                  icon: const Icon(Icons.flip_to_back, size: 75),
                  label: const Text('도서반납', style: TextStyle(fontSize: 25))),
              TextButton.icon(
                  onPressed: () => context.push(Uri(path: '/borrow/renewal').toString()),
                  icon: const Icon(Icons.post_add, size: 75),
                  label: const Text('대출연장', style: TextStyle(fontSize: 25))),
              TextButton.icon(
                  onPressed: () => context.push(Uri(path: '/borrow/history').toString()),
                  icon: const Icon(Icons.history_edu, size: 75),
                  label: const Text('대출현황', style: TextStyle(fontSize: 25))),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
