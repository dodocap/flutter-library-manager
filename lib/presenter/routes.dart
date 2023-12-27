import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/presenter/book/book_add_screen.dart';
import 'package:orm_library_manager/presenter/book/book_list_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_list_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_main_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_renewal_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_result_screen.dart';
import 'package:orm_library_manager/presenter/borrow/borrow_return_list_screen.dart';
import 'package:orm_library_manager/presenter/main/main_screen.dart';
import 'package:orm_library_manager/presenter/member/member_join_screen.dart';
import 'package:orm_library_manager/presenter/member/member_list_screen.dart';

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
                    return BorrowReturnListScreen(member: member);
                    // return BorrowReturnScreen(mode: ScreenMode.selectorReturner, member: member);
                  }),
                ]
              ),
              GoRoute(path: 'renewal', builder: (_, __) => BorrowRenewalScreen()),
              GoRoute(path: 'history', builder: (_, __) => BorrowListScreen()),
            ],
          ),
          GoRoute(path: 'result', builder: (_, state) {
            final Member member = Member.fromJson(jsonDecode(state.uri.queryParameters['member']!));
            final Book book = Book.fromJson(jsonDecode(state.uri.queryParameters['book']!));
            final ScreenMode mode = ScreenMode.getByString(state.uri.queryParameters['mode']!);
            return BorrowResultScreen(member: member, book: book, mode: mode);
          })
        ],
      ),
    ]
);