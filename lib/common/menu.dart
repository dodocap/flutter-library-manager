import 'package:flutter/material.dart';
import 'package:orm_library_manager/presenter/book/book_list_screen.dart';
import 'package:orm_library_manager/presenter/member/member_join_screen.dart';
import 'package:orm_library_manager/presenter/member/member_list_screen.dart';
import 'package:orm_library_manager/presenter/member/member_screen.dart';

final Map<String, Widget> mainMenuMap = {
  '1. 회원 관리': MemberListScreen(),
  '2. 도서 관리': BookListScreen(),
};
