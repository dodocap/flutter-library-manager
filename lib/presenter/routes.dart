import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/domain/dto/book.dart';
import 'package:orm_library_manager/domain/dto/member.dart';
import 'package:orm_library_manager/domain/model/borrow_info_model.dart';
import 'package:orm_library_manager/presenter/book/book_add_screen.dart';
import 'package:orm_library_manager/presenter/book/book_list_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_list_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_main_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_result_screen.dart';
import 'package:orm_library_manager/presenter/main/main_screen.dart';
import 'package:orm_library_manager/presenter/member/member_join_screen.dart';
import 'package:orm_library_manager/presenter/member/member_list_screen.dart';
import 'package:orm_library_manager/presenter/renewal/renewal_list_screen.dart';
import 'package:orm_library_manager/presenter/renewal/renewal_result_screen.dart';
import 'package:orm_library_manager/presenter/return/return_list_screen.dart';
import 'package:orm_library_manager/presenter/return/return_result_screen.dart';

final routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const MainScreen(),
        routes: [
          GoRoute(path: 'member', builder: (_, __) => const MemberListScreen(mode: ScreenMode.editor),
            routes: [
              GoRoute(path: 'join', builder: (_, __) =>const MemberJoinScreen())
            ]
          ),
          GoRoute(path: 'book', builder: (_, __) => const BookListScreen(mode: ScreenMode.editor),
            routes: [
              GoRoute(path: 'add', builder: (_, __) => const BookAddScreen())
            ]
          ),
          GoRoute(path: 'borrow', builder: (_, __) => const BorrowMainScreen(),
            routes: [
              GoRoute(path: 'member', builder: (_, __) => const MemberListScreen(mode: ScreenMode.selectorBurrower),
                routes: [
                  GoRoute(path: 'book', builder: (_, state) {
                    final Member member = Member.fromJson(jsonDecode(state.uri.queryParameters['member']!));
                    return BookListScreen(mode: ScreenMode.selectorBurrower, member: member);
                  }),
                ]
              ),
              GoRoute(path: 'return', builder: (_, __) => const MemberListScreen(mode: ScreenMode.selectorReturner),
                routes: [
                  GoRoute(path: 'book', builder: (_, state) {
                    final Member member = Member.fromJson(jsonDecode(state.uri.queryParameters['member']!));
                    return ReturnListScreen(member: member);
                  }),
                ]
              ),
              GoRoute(path: 'renewal', builder: (_, __) => const MemberListScreen(mode: ScreenMode.selectorRenewal),
                routes: [
                  GoRoute(path: 'book', builder: (_, state) {
                    final Member member = Member.fromJson(jsonDecode(state.uri.queryParameters['member']!));
                    return RenewalListScreen(member: member);
                  }),
                ]
              ),
              GoRoute(path: 'history', builder: (_, __) => const BorrowListScreen()),
            ],
          ),
          GoRoute(path: 'resultBorrow', builder: (_, state) {
            final Member member = Member.fromJson(jsonDecode(state.uri.queryParameters['member']!));
            final Book book = Book.fromJson(jsonDecode(state.uri.queryParameters['book']!));
            return BorrowResultScreen(member: member, book: book);
          }),
          GoRoute(path: 'resultReturn', builder: (_, state) {
            final BorrowInfoModel borrowInfoModel = BorrowInfoModel.fromJson(jsonDecode(state.uri.queryParameters['borrowInfoModel']!));
            return ReturnResultScreen(borrowInfoModel: borrowInfoModel);
          }),
          GoRoute(path: 'resultRenewal', builder: (_, state) {
            final BorrowInfoModel borrowInfoModel = BorrowInfoModel.fromJson(jsonDecode(state.uri.queryParameters['borrowInfoModel']!));
            return RenewalResultScreen(borrowInfoModel: borrowInfoModel);
          }),
        ],
      ),
    ]
);