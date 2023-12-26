import 'dart:math';

import 'package:orm_library_manager/common/common.dart';
import 'package:orm_library_manager/common/constants.dart';
import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/member.dart';
import 'package:orm_library_manager/domain/repository/borrow_repository.dart';

class BorrowMemoryRepository implements BorrowRepository {
  final List<BorrowInfo> _borrowInfoList = [];

  Future<void> _virtualDelayed() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(150) + 150));
  }

  @override
  Future<Result<List<BorrowInfo>>> getAllHistory() async {
    await _virtualDelayed();

    return Success(_borrowInfoList);
  }

  @override
  Future<Result<List<BorrowInfo>>> getAllBorrows() async {
    await _virtualDelayed();

    return Success(_borrowInfoList.where((element) => !element.isFinished).toList());
  }

  @override
  Future<Result<BorrowInfo>> borrowBook(Member member, Book book) async {
    await _virtualDelayed();

    if (book.isBorrowed) {
      return Future.error(errAlreadyBorrowed);
    }

    book.setBorrowed = true;
    final BorrowInfo borrowInfo = BorrowInfo(
      memberId: member.id,
      bookId: book.id,
    );
    _borrowInfoList.add(borrowInfo);
    return Success(borrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> returnBook(Member member, Book book) async {
    await _virtualDelayed();

    final BorrowInfo? borrowInfo = _borrowInfoList.firstWhereOrNull((info) {
      return info.bookId == book.id &&info.memberId == member.id;
    });

    if(borrowInfo == null) {
      return Future.error(errNotFoundBorrowInfo);
    }

    borrowInfo.setReturn();
    return Success(borrowInfo);
  }

  @override
  Future<Result<BorrowInfo>> renewalBook(Member member, Book book) {
    return Future.value();
  }
}
