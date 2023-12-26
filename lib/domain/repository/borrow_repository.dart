import 'package:orm_library_manager/common/result.dart';
import 'package:orm_library_manager/domain/model/book.dart';
import 'package:orm_library_manager/domain/model/borrow_info.dart';
import 'package:orm_library_manager/domain/model/member.dart';

abstract interface class BorrowRepository {
  Future<Result<List<BorrowInfo>>> getAll();
  Future<Result<BorrowInfo>> borrowBook(Member member, Book book);
  Future<Result<BorrowInfo>> returnBook(Member member, Book book);
  Future<Result<BorrowInfo>> renewalBook(Member member, Book book);
}