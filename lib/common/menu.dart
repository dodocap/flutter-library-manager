import 'package:flutter/material.dart';
import 'package:orm_library_manager/presenter/member/member_join_screen.dart';
import 'package:orm_library_manager/presenter/member/member_list_screen.dart';
import 'package:orm_library_manager/presenter/member/member_screen.dart';

final Map<String, Widget> mainMenuMap = {
  '1. 회원 관리': MemberScreen(),
};

final Map<String, Widget> memberMenuMap = {
  '1. 회원 조회' : MemberListScreen(),
  '2. 회원 추가' : MemberJoinScreen(),
  '3. 회원 탈퇴' : MemberScreen(),
  '4. 회원 탈퇴 철회' : MemberScreen(),
};