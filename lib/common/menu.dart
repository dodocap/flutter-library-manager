import 'package:flutter/material.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/presenter/book/book_list_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_main_screen.dart';
import 'package:orm_library_manager/presenter/member/member_list_screen.dart';

final Map<String, Widget> mainMenuMap = {
  '1. 회원 관리': const MemberListScreen(mode: ScreenMode.editor),
  '2. 도서 관리': const BookListScreen(mode: ScreenMode.editor),
  '3. 대출 관리': const BorrowMainScreen(),
};

final Map<String, Widget> borrowMenuMap = {
  '1. 도서 대출': const MemberListScreen(mode: ScreenMode.selector),
  '2. 도서 반납': const BorrowMainScreen(),
  '3. 대출 연장': const BorrowMainScreen(),
  '4. 대출 현황': const BorrowMainScreen(),
};
