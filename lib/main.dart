import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/repositories.dart';
import 'package:orm_library_manager/data/repository_impl/file/book_file_repository.dart';
import 'package:orm_library_manager/data/repository_impl/file/borrow_file_repository.dart';
import 'package:orm_library_manager/data/repository_impl/file/member_file_repository.dart';
import 'package:orm_library_manager/presenter/main/main_screen.dart';
import 'package:orm_library_manager/presenter/routes.dart';

void main() {
  runApp(const MyApp());

  memberRepository = MemberFileRepository();
  bookRepository = BookFileRepository();
  borrowRepository = BorrowFileRepository();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routes,
      title: '도서관리 프로그램',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}